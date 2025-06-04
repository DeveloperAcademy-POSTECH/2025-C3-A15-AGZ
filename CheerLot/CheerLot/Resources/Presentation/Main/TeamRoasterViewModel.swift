//
//  TeamRoasterViewModel.swift
//  CheerLot
//
//  Created by 이현주 on 5/31/25.
//

import Foundation
import Observation
import SwiftData
import SwiftUI

@Observable
class TeamRoasterViewModel {

  // MARK: - Properties

  var selectedSegment: MemberListMenuSegment = .starting
  private let networkService = LineupNetworkService()
  var players: [Player] = []
  var isLoading = false
  var errorMessage: String?
  var lastUpdated: String = ""
  var opponent: String = ""

  private var modelContext: ModelContext?
  private var currentTheme: Theme = .SS

  // MARK: - Initialization

  init() {}

  func setModelContext(_ context: ModelContext) {
    self.modelContext = context
  }

  func setTheme(_ theme: Theme) {
    self.currentTheme = theme
  }

  // MARK: - Public Methods

  /// API에서 선수 라인업을 가져오거나 실패 시 로컬 데이터를 조회합니다.
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

  // MARK: - Private Methods

  /// API 응답으로 로컬 데이터를 업데이트합니다.
  private func updateLocalData(from response: LineupResponse, teamCode: String) async {
    guard let modelContext = self.modelContext else {
      print("⚠️ ModelContext가 설정되지 않았습니다")
      return
    }

    // API 응답에 선수 정보가 없으면 로컬 데이터 업데이트를 건너뛰도록 합니다.
    guard !response.players.isEmpty else {
      print("ℹ️ API 응답에 선수 정보가 없습니다. 로컬 데이터를 변경하지 않습니다.")
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
        let localPlayers = team.teamMemeberList
      {
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

  /// 로컬 데이터에서 선수 정보를 조회합니다.
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
        let allPlayers = team.teamMemeberList
      {
        await MainActor.run {
          // 타순이 있는 선수들만 필터링하고 타순 순서대로 정렬
          let startingPlayers =
            allPlayers
            .filter { $0.battingOrder > 0 }
            .sorted { $0.battingOrder < $1.battingOrder }

          // 상위 9명만 선택하여 표시
          self.players = Array(startingPlayers.prefix(9))
          self.lastUpdated = team.lastUpdated
          self.opponent = "\(self.currentTheme.shortName) vs \(team.lastOpponent)"
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

  /// DTO를 Player 모델로 변환합니다.
  private func convertToPlayer(from dto: PlayerDTO) -> Player {
    let battingOrder = Int(dto.batsOrder) ?? 0
    let id = Int(dto.backNumber) ?? 0
    let position = dto.position + " / " + dto.batsThrows

    return Player(
      cheerSongList: nil,
      id: id,
      name: dto.name,
      position: position,
      battingOrder: battingOrder
    )
  }

  /// 에러를 처리하고 적절한 에러 메시지를 설정합니다.
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

  var backupPlayer: [Player] = [
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
    Player(
      cheerSongList: [
        CheerSong(title: "기본 응원가", lyrics: "", audioFileName: ""),
        CheerSong(title: "안타", lyrics: "", audioFileName: ""),
      ], id: 9, name: "김현수", position: "LF", battingOrder: 1),
    Player(
      cheerSongList: [CheerSong(title: "기본 응원가", lyrics: "", audioFileName: "")], id: 10,
      name: "박해민", position: "CF", battingOrder: 2),
    Player(
      cheerSongList: [CheerSong(title: "기본 응원가", lyrics: "", audioFileName: "")], id: 11,
      name: "오지환", position: "RF", battingOrder: 3),
    Player(id: 12, name: "채은성", position: "RF", battingOrder: 4),
    Player(
      cheerSongList: [
        CheerSong(title: "기본 응원가", lyrics: "", audioFileName: ""),
        CheerSong(title: "안타", lyrics: "", audioFileName: ""),
      ], id: 13, name: "문보경", position: "3B", battingOrder: 5),
    Player(
      cheerSongList: [
        CheerSong(title: "기본 응원가", lyrics: "", audioFileName: ""),
        CheerSong(title: "안타", lyrics: "", audioFileName: ""),
      ], id: 14, name: "김민성", position: "2B", battingOrder: 6),
    Player(
      cheerSongList: [CheerSong(title: "기본 응원가", lyrics: "", audioFileName: "")], id: 15,
      name: "유강남", position: "C", battingOrder: 7),
    Player(
      cheerSongList: [
        CheerSong(title: "기본 응원가", lyrics: "", audioFileName: ""),
        CheerSong(title: "안타", lyrics: "", audioFileName: ""),
      ], id: 16, name: "서건창", position: "1B", battingOrder: 8),
    Player(id: 17, name: "이재원", position: "DH", battingOrder: 9),
  ]
}
