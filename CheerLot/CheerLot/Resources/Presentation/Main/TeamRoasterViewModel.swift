//
//  TeamRoasterViewModel.swift
//  CheerLot
//
//  Created by 이현주 on 5/31/25.
//

import Foundation
import Observation
import SwiftUI
import SwiftData

@Observable
class TeamRoasterViewModel: ObservableObject {

  var selectedSegment: MemberListMenuSegment = .starting
  private let networkService = LineupNetworkService()
  var players: [Player] = []
  var isLoading = false
  var errorMessage: String?
  var lastUpdated: String = ""
  var opponent: String = ""
  
  private var modelContext: ModelContext?
  private var currentTheme: Theme = .SS
  
  init() {}
  
  func setModelContext(_ context: ModelContext) {
    self.modelContext = context
  }
  
  func setTheme(_ theme: Theme) {
    self.currentTheme = theme
  }

  // API 호출 메서드
  func fetchLineup(for teamCode: String) async {
    await MainActor.run {
      isLoading = true
      errorMessage = nil
    }

    do {
      let response = try await networkService.fetchLineup(teamCode: teamCode)
      
      // API 응답으로 로컬 데이터 업데이트
      await updateLocalData(from: response, teamCode: teamCode)
      
      // 로컬 데이터에서 선수 정보 조회
      await loadPlayersFromLocal(teamCode: teamCode)
      
    } catch {
      print("API 호출 실패: \(error)")
      // API 호출 실패 시 로컬 데이터만 조회
      await loadPlayersFromLocal(teamCode: teamCode)
    }
  }
  
  // 로컬 데이터 업데이트
  private func updateLocalData(from response: LineupResponse, teamCode: String) async {
    guard let modelContext = self.modelContext else {
      print("⚠️ ModelContext가 설정되지 않았습니다")
      return
    }
    
    print("📌 API 응답으로 로컬 데이터 업데이트 시작")
    
    do {
      let searchTeamCode = teamCode.lowercased()
      let descriptor = FetchDescriptor<Team>(
        predicate: #Predicate<Team> { team in
          team.themeRaw == searchTeamCode
        }
      )
      
      if let team = try modelContext.fetch(descriptor).first,
         let localPlayers = team.teamMemeberList {
        print("✅ SwiftData에서 팀 정보 조회 성공")
        
        let apiPlayers = response.players.map { dto in
          convertToPlayer(from: dto)
        }
        
        var updatedCount = 0
        var unmatchedCount = 0
        
        // API로 받아온 선수들의 정보로 SwiftData 업데이트
        for localPlayer in localPlayers {
          print("\n🔄 로컬 선수 정보 업데이트 시도: \(localPlayer.name)")
          
          if let apiPlayer = apiPlayers.first(where: { $0.name == localPlayer.name }) {
            print("✅ API에서 매칭되는 선수 찾음")
            
            await MainActor.run {
              let oldBattingOrder = localPlayer.battingOrder
              let oldPosition = localPlayer.position
              
              localPlayer.battingOrder = apiPlayer.battingOrder
              localPlayer.position = apiPlayer.position
              
              print("✨ 로컬 선수 정보 업데이트 완료")
              print("- 이전: 타순=\(oldBattingOrder), 포지션=\(oldPosition)")
              print("- 이후: 타순=\(localPlayer.battingOrder), 포지션=\(localPlayer.position)")
            }
            updatedCount += 1
          } else {
            print("⚠️ API에서 매칭되는 선수를 찾을 수 없음")
            print("🔄 교체 선수로 상태 변경")
            
            await MainActor.run {
              let oldBattingOrder = localPlayer.battingOrder
              let oldPosition = localPlayer.position
              
              localPlayer.battingOrder = 0
              localPlayer.position = "교체 선수"
              
              print("✨ 교체 선수 상태 변경 완료")
              print("- 이전: 타순=\(oldBattingOrder), 포지션=\(oldPosition)")
              print("- 이후: 타순=0, 포지션=교체 선수")
            }
            unmatchedCount += 1
          }
        }
        
        // 마지막 업데이트 정보와 상대팀 정보 업데이트
        team.lastUpdated = response.updated
        team.lastOpponent = response.opponent
        
        print("\n📊 업데이트 통계")
        print("- 전체 로컬 선수: \(localPlayers.count)")
        print("- 업데이트된 선수: \(updatedCount)")
        print("- 교체 선수로 변경: \(unmatchedCount)")
      }
    } catch {
      print("❌ SwiftData 로컬 데이터 업데이트 실패: \(error)")
    }
  }
  
  // 로컬 데이터에서 선수 정보 조회
  private func loadPlayersFromLocal(teamCode: String) async {
    guard let modelContext = self.modelContext else {
      print("⚠️ ModelContext가 설정되지 않았습니다")
      await MainActor.run {
        self.isLoading = false
        self.errorMessage = "데이터를 불러올 수 없습니다."
      }
      return
    }
    
    print("📌 로컬 데이터에서 선수 정보 조회 시작")
    
    do {
      let searchTeamCode = teamCode.lowercased()
      let descriptor = FetchDescriptor<Team>(
        predicate: #Predicate<Team> { team in
          team.themeRaw == searchTeamCode
        }
      )
      
      if let team = try modelContext.fetch(descriptor).first,
         let allPlayers = team.teamMemeberList {
        await MainActor.run {
          // 타순이 있는 선수들만 필터링하고 타순 순서대로 정렬
          let startingPlayers = allPlayers
            .filter { $0.battingOrder > 0 }
            .sorted { $0.battingOrder < $1.battingOrder }
          
          // 상위 9명만 선택하여 표시
          self.players = Array(startingPlayers.prefix(9))
          self.lastUpdated = team.lastUpdated
          self.opponent = "\(getTeamName(from: teamCode)) vs \(team.lastOpponent)"
          self.isLoading = false
          print("✅ 로컬 데이터 조회 완료")
          print("- 전체 선수: \(allPlayers.count)")
          print("- 선발 선수: \(self.players.count)")
        }
      } else {
        await MainActor.run {
          self.isLoading = false
          self.errorMessage = "팀 정보를 찾을 수 없습니다."
        }
        print("⚠️ 팀 정보를 찾을 수 없음")
      }
    } catch {
      await MainActor.run {
        self.isLoading = false
        self.errorMessage = "데이터 조회 중 오류가 발생했습니다."
      }
      print("❌ 로컬 데이터 조회 실패: \(error)")
    }
  }

  // DTO 변환 메서드
  private func convertPlayers(from response: LineupResponse) -> [Player] {
    print("\n📥 API 응답 변환 시작")
    print("- 받은 선수 수: \(response.players.count)")
    
    let players = response.players.compactMap { dto in
      convertToPlayer(from: dto)
    }
    .sorted { $0.battingOrder < $1.battingOrder }  // 타순 순서로 정렬
    
    print("- 변환된 선수 수: \(players.count)")
    print("- 첫 번째 선수: \(players.first?.name ?? "없음") (타순: \(players.first?.battingOrder ?? 0))")
    
    // SwiftData에서 선수 정보 업데이트
    Task { @MainActor in
      await updatePlayersFromSwiftData(players)
    }
    
    return players
  }
  
  // SwiftData에서 선수 정보 업데이트
  private func updatePlayersFromSwiftData(_ apiPlayers: [Player]) async {
    guard let modelContext = self.modelContext else {
      print("⚠️ ModelContext가 설정되지 않았습니다")
      return
    }
    
    print("📌 SwiftData 로컬 데이터 업데이트 시작")
    print("- 현재 팀: \(currentTheme.rawValue)")
    print("- API에서 받아온 선수 수: \(apiPlayers.count)")
    
    do {
      let teamCode = currentTheme.rawValue.lowercased()
      let descriptor = FetchDescriptor<Team>(
        predicate: #Predicate<Team> { team in
          team.themeRaw == teamCode
        }
      )
      
      if let team = try modelContext.fetch(descriptor).first,
         let localPlayers = team.teamMemeberList {
        print("✅ SwiftData에서 팀 정보 조회 성공")
        print("- 로컬에 저장된 선수 수: \(localPlayers.count)")
        
        var updatedCount = 0
        var unmatchedCount = 0
        // API로 받아온 선수들의 정보로 SwiftData 업데이트
        for localPlayer in localPlayers {
          print("\n🔄 로컬 선수 정보 업데이트 시도: \(localPlayer.name)")
          print("- 현재 로컬 정보: 타순=\(localPlayer.battingOrder), 포지션=\(localPlayer.position)")
          
          if let apiPlayer = apiPlayers.first(where: { $0.name == localPlayer.name }) {
            print("✅ API에서 매칭되는 선수 찾음")
            print("- API 정보: 타순=\(apiPlayer.battingOrder), 포지션=\(apiPlayer.position)")
            
            await MainActor.run {
              let oldBattingOrder = localPlayer.battingOrder
              let oldPosition = localPlayer.position
              
              localPlayer.battingOrder = apiPlayer.battingOrder
              localPlayer.position = apiPlayer.position
              
              print("✨ 로컬 선수 정보 업데이트 완료")
              print("- 이전: 타순=\(oldBattingOrder), 포지션=\(oldPosition)")
              print("- 이후: 타순=\(localPlayer.battingOrder), 포지션=\(localPlayer.position)")
            }
            updatedCount += 1
          } else {
            print("⚠️ API에서 매칭되는 선수를 찾을 수 없음")
            print("🔄 교체 선수로 상태 변경")
            
            await MainActor.run {
              let oldBattingOrder = localPlayer.battingOrder
              let oldPosition = localPlayer.position
              
              localPlayer.battingOrder = 0
              localPlayer.position = "교체 선수"
              
              print("✨ 교체 선수 상태 변경 완료")
              print("- 이전: 타순=\(oldBattingOrder), 포지션=\(oldPosition)")
              print("- 이후: 타순=0, 포지션=교체 선수")
            }
            unmatchedCount += 1
          }
        }
        
        // 마지막 업데이트 정보와 상대팀 정보 업데이트
        team.lastUpdated = lastUpdated
        team.lastOpponent = opponent
        
        print("\n📊 업데이트 통계")
        print("- 전체 로컬 선수: \(localPlayers.count)")
        print("- 업데이트된 선수: \(updatedCount)")
        print("- 교체 선수로 변경: \(unmatchedCount)")
      } else {
        print("⚠️ SwiftData에서 팀 정보를 찾을 수 없음")
      }
    } catch {
      print("❌ SwiftData 로컬 데이터 업데이트 실패: \(error)")
    }
  }

  // 개별 Player 변환 메서드
  private func convertToPlayer(from dto: PlayerDTO) -> Player {
    let battingOrder = Int(dto.batsOrder) ?? 0
    let id = Int(dto.backNumber) ?? 0
    let position = dto.position + " / " + dto.batsThrows

    print("🔄 선수 변환: \(dto.name)")
    print("- 등번호: \(dto.backNumber)")
    print("- 타순: \(dto.batsOrder)")
    print("- 포지션: \(position)")

    return Player(
      cheerSongList: nil,
      id: id,
      name: dto.name,
      position: position,
      battingOrder: battingOrder
    )
  }

  // 에러 처리 메서드
  private func handleError(_ error: Error) {
    if let networkError = error as? NetworkError {
      switch networkError {
      case .decodingError:
        errorMessage = "데이터 형식이 올바르지 않습니다."
      case .moyaError(let moyaError):
        switch moyaError {
        case .underlying(let nsError, _):
          if (nsError as NSError).code == NSURLErrorNotConnectedToInternet {
            errorMessage = "인터넷 연결을 확인해주세요."
          } else if (nsError as NSError).code == NSURLErrorTimedOut {
            errorMessage = "요청 시간이 초과되었습니다."
          } else {
            errorMessage = "네트워크 오류가 발생했습니다."
          }
        case .statusCode(let response):
          if response.statusCode == 404 {
            errorMessage = "선수 명단 정보를 찾을 수 없습니다."
          } else if response.statusCode >= 500 {
            errorMessage = "서버에 일시적인 문제가 발생했습니다."
          } else {
            errorMessage = "요청을 처리할 수 없습니다. (상태코드: \(response.statusCode))"
          }
        default:
          errorMessage = "네트워크 요청 중 오류가 발생했습니다."
        }
      }
    } else {
      errorMessage = "알 수 없는 오류가 발생했습니다."
    }
  }

  private func getTeamName(from teamCode: String) -> String {
    switch teamCode.uppercased() {
    case "SS": return "삼성"
    case "HH": return "한화"
    case "LG": return "LG"
    case "LT": return "롯데"
    case "NC": return "NC"
    case "SK": return "SK"
    case "OB": return "두산"
    case "KT": return "KT"
    case "WO": return "키움"
    case "HT": return "KIA"
    default: return teamCode
    }
  }

  var dummyPlayers: [Player] = [
    Player(
      cheerSongList: [
        CheerSong(title: "기본 응원가", lyrics: "", audioFileName: ""),
        CheerSong(title: "안타", lyrics: "", audioFileName: ""),
      ], id: 0, name: "김현수", position: "LF", battingOrder: 1),
    Player(
      cheerSongList: [CheerSong(title: "기본 응원가", lyrics: "", audioFileName: "")], id: 1,
      name: "박해민", position: "CF", battingOrder: 2),
    Player(
      cheerSongList: [CheerSong(title: "기본 응원가", lyrics: "", audioFileName: "")], id: 2,
      name: "오지환", position: "RF", battingOrder: 3),
    Player(id: 3, name: "채은성", position: "RF", battingOrder: 4),
    Player(
      cheerSongList: [
        CheerSong(title: "기본 응원가", lyrics: "", audioFileName: ""),
        CheerSong(title: "안타", lyrics: "", audioFileName: ""),
      ], id: 4, name: "문보경", position: "3B", battingOrder: 5),
    Player(
      cheerSongList: [
        CheerSong(title: "기본 응원가", lyrics: "", audioFileName: ""),
        CheerSong(title: "안타", lyrics: "", audioFileName: ""),
      ], id: 5, name: "김민성", position: "2B", battingOrder: 6),
    Player(
      cheerSongList: [CheerSong(title: "기본 응원가", lyrics: "", audioFileName: "")], id: 6,
      name: "유강남", position: "C", battingOrder: 7),
    Player(
      cheerSongList: [
        CheerSong(title: "기본 응원가", lyrics: "", audioFileName: ""),
        CheerSong(title: "안타", lyrics: "", audioFileName: ""),
      ], id: 7, name: "서건창", position: "1B", battingOrder: 8),
    Player(id: 8, name: "이재원", position: "DH", battingOrder: 9),
  ]
}
