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
import WatchConnectivity

@Observable
class TeamRoasterViewModel: NSObject, WCSessionDelegate {  // watchOS와의 연결을 관리위해 NSObject, WCSessionDelegate 프로토콜 채택

  var session: WCSession
  init(session: WCSession = .default) {
    self.session = session
    super.init()
    session.delegate = self
    session.activate()
  }

  // MARK: - Properties

  var selectedSegment: MemberListMenuSegment = .starting
  private let networkService = LineupNetworkService()
  var players: [Player] = [] {
    didSet {
      print("선발 선수 리스트 변경됨. watch로 전송 시작")

      let playerDTOs = players.map { player in
        PlayerWatchDto(
          cheerSongList: (player.cheerSongList ?? []).map {
            CheerSongWatchDto(
              title: $0.title,
              lyrics: $0.lyrics,
              audioFileName: $0.audioFileName
            )
          }, id: player.id, name: player.name, position: player.position,
          battingOrder: player.battingOrder)
      }

      if session.isPaired && session.isWatchAppInstalled {
        do {
          let encoded = try JSONEncoder().encode(playerDTOs)
          print("watch 전송 데이터 크기: \(encoded.count) bytes")
          session.transferUserInfo(["players": encoded])
        } catch {
          print("인코딩 실패: \(error)")
        }
      }
    }
  }
  var allPlayers: [Player] = []
  var backupPlayers: [Player] = []
  var isLoading = false
  var errorMessage: String?
  var lastUpdated: String = "" {
    didSet {
      if session.isPaired && session.isWatchAppInstalled {
        let userInfo: [String: Any] = ["Date": self.lastUpdated]
        session.transferUserInfo(userInfo)
      }
    }
  }
  var opponent: String = ""

  private var modelContext: ModelContext?
  private var currentTheme: Theme = .SS

  // MARK: - Initialization

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
      await loadAllPlayersFromLocal(teamCode: teamCode)

    } catch {
      print("API 호출 실패: \(error)")
      // API 호출 실패 시 로컬 데이터만 조회
      await loadPlayersFromLocal(teamCode: teamCode)
      await loadAllPlayersFromLocal(teamCode: teamCode)
    }
  }

  /// 두 선수의 타순을 교환합니다.
  func swapBattingOrder(playerToBench: Player, playerToStart: Player) async {
    print("🔄 [SwapBattingOrder] 타순 교환 시작: \(playerToBench.name) <-> \(playerToStart.name)")

    guard let modelContext = self.modelContext else {
      print("🚨 [SwapBattingOrder] 실패: ModelContext가 설정되지 않았습니다.")
      return
    }

    let benchPlayerID = playerToBench.id
    let startPlayerID = playerToStart.id

    // SwiftData에서 최신 선수 객체 가져오기
    var fetchedBenchPlayer: Player?
    var fetchedStartPlayer: Player?

    do {
      var descriptor = FetchDescriptor<Player>(predicate: #Predicate { $0.id == benchPlayerID })
      fetchedBenchPlayer = try modelContext.fetch(descriptor).first

      descriptor = FetchDescriptor<Player>(predicate: #Predicate { $0.id == startPlayerID })
      fetchedStartPlayer = try modelContext.fetch(descriptor).first
    } catch {
      print("🚨 [SwapBattingOrder] 실패: 선수 조회 중 SwiftData 오류 - \(error)")
      return
    }

    guard let benchPlayerInContext = fetchedBenchPlayer else {
      print("🚨 [SwapBattingOrder] 실패: 교체 대상 선수(ID: \(benchPlayerID))를 찾을 수 없습니다.")
      return
    }
    guard let startPlayerInContext = fetchedStartPlayer else {
      print("🚨 [SwapBattingOrder] 실패: 투입 선수(ID: \(startPlayerID))를 찾을 수 없습니다.")
      return
    }

    // 타순 교환
    let originalBenchOrder = benchPlayerInContext.battingOrder
    let originalStartOrder = startPlayerInContext.battingOrder

    benchPlayerInContext.battingOrder = originalStartOrder
    startPlayerInContext.battingOrder = originalBenchOrder

    // 변경사항 저장
    do {
      try modelContext.save()
      print("✅ [SwapBattingOrder] 타순 교환 및 저장 완료.")

      // 데이터 리프레시 (UI 업데이트 위해)
      print("🔄 [SwapBattingOrder] 선수 목록 데이터 리프레시 시작.")
      let teamCode = self.currentTheme.rawValue
      await loadPlayersFromLocal(teamCode: teamCode)
      await loadAllPlayersFromLocal(teamCode: teamCode)
      print("✅ [SwapBattingOrder] 선수 목록 데이터 리프레시 완료.")

    } catch {
      print("🚨 [SwapBattingOrder] 실패: SwiftData 저장 중 오류 - \(error)")
      // 오류 발생 시 타순 롤백
      benchPlayerInContext.battingOrder = originalBenchOrder
      startPlayerInContext.battingOrder = originalStartOrder
      print("  [SwapBattingOrder] 타순 롤백 완료.")
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

    do {
      let searchTeamCode = teamCode.lowercased()
      let descriptor = FetchDescriptor<Team>(
        predicate: #Predicate<Team> { team in
          team.themeRaw == searchTeamCode
        }
      )

      if let team = try modelContext.fetch(descriptor).first {
        // 로컬 데이터의 lastUpdated와 API 응답의 updated 시간이 같은지 확인
        guard team.lastUpdated != response.updated else {
          print("ℹ️ API 데이터와 로컬 데이터의 업데이트 시간이 '\(response.updated)'(으)로 동일하여, 로컬 데이터를 변경하지 않습니다.")
          return
        }

        print("📌 API 응답으로 로컬 데이터 업데이트 시작 (API: \(response.updated), Local: \(team.lastUpdated))")

        guard let localPlayers = team.teamMemeberList else {
          print("⚠️ 팀(\(searchTeamCode))의 teamMemeberList가 nil입니다. 업데이트를 진행할 수 없습니다.")
          return
        }

        print("✅ SwiftData에서 팀 정보 조회 성공")

        let apiPlayers = response.players.map { dto in
          convertToPlayer(from: dto)
        }

        var updatedCount = 0
        var unmatchedCount = 0

        // API로 받아온 선수들의 정보로 SwiftData 업데이트
        for localPlayer in localPlayers {

          if let apiPlayer = apiPlayers.first(where: { $0.name == localPlayer.name }) {
            await MainActor.run {
              let oldBattingOrder = localPlayer.battingOrder
              let oldPosition = localPlayer.position

              localPlayer.battingOrder = apiPlayer.battingOrder
              localPlayer.position = apiPlayer.position
            }
            updatedCount += 1
          } else {
            await MainActor.run {
              let oldBattingOrder = localPlayer.battingOrder
              let oldPosition = localPlayer.position

              localPlayer.battingOrder = 0
              localPlayer.position = "교체 선수"
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

          // 타순이 0인 선수들을 backupPlayers에 할당
          let benchPlayers = allPlayers.filter { $0.battingOrder == 0 }
          // 이름 순으로 정렬
          self.backupPlayers = benchPlayers.sorted { $0.name < $1.name }

          print("✅ 로컬 데이터 조회 완료")
          print("- 전체 선수: \(allPlayers.count)")
          print("- 선발 선수: \(self.players.count)")
          print("- 백업 선수 (backupPlayers, 이름 정렬됨): \(self.backupPlayers.count)")
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

  /// 로컬 데이터에서 모든 선수 정보를 조회하여 allPlayers에 저장합니다.
  private func loadAllPlayersFromLocal(teamCode: String) async {
    guard let modelContext = self.modelContext else {
      print("⚠️ ModelContext가 설정되지 않았습니다")
      return
    }

    print("📌 로컬 데이터에서 모든 선수 정보 조회 시작 (allPlayers)")

    do {
      let searchTeamCode = teamCode.lowercased()
      let descriptor = FetchDescriptor<Team>(
        predicate: #Predicate<Team> { team in
          team.themeRaw == searchTeamCode
        }
      )

      if let team = try modelContext.fetch(descriptor).first,
        let localAllPlayers = team.teamMemeberList
      {
        await MainActor.run {
          // 응원가가 있는 선수들만 필터링
          let playersWithCheerSongs = localAllPlayers.filter { player in
            guard let songs = player.cheerSongList, !songs.isEmpty else {
              return false  // 응원가 리스트가 nil이거나 비어있으면 제외
            }
            return true  // 응원가가 하나 이상 있으면 포함
          }
          // 이름 순으로 정렬
          self.allPlayers = playersWithCheerSongs.sorted { $0.name < $1.name }
          print("✅ 로컬 데이터 모든 선수 조회 완료 (allPlayers - 응원가 필터 및 이름 정렬 적용됨)")
          print("- 원본 전체 선수: \(localAllPlayers.count)")
          print("- 응원가 보유 및 정렬된 선수 (allPlayers): \(self.allPlayers.count)")
        }
      } else {
        print("⚠️ 팀 정보를 찾을 수 없음 (allPlayers)")
      }
    } catch {
      print("❌ 로컬 데이터 모든 선수 조회 실패 (allPlayers): \(error)")
    }
  }

  /// DTO를 Player 모델로 변환합니다.
  private func convertToPlayer(from dto: PlayerDTO) -> Player {
    let battingOrder = Int(dto.batsOrder) ?? 0
    let id = Int(dto.backNumber) ?? 0
    let position = dto.position + ", " + dto.batsThrows

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

  // MARK: - watchOS 연결을 위한 session
  // WCSessionDelegate 준수 시에 3가지 delegate method 정의
  func session(
    _ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState,
    error: Error?
  ) {

  }

  func sessionDidBecomeInactive(_ session: WCSession) {

  }

  func sessionDidDeactivate(_ session: WCSession) {

  }
}
