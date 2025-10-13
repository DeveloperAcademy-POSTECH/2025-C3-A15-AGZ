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
final class TeamRoasterViewModel {

  static let shared = TeamRoasterViewModel()

  // MARK: - Properties
  var selectedSegment: MemberListMenuSegment = .starting
  private let versionNetworkService = VersionNetworkService()
  private let playersNetworkService = PlayersNetworkService()

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
          }, id: player.id, jerseyNumber: player.jerseyNumber, name: player.name,
          position: player.position,
          battingOrder: player.battingOrder)
      }

      WatchSessionManager.shared.sendPlayerList(playerDTOs)
    }
  }
  var allPlayers: [Player] = []
  var backupPlayers: [Player] = []

  var isLoadingPlayers: Bool = false  // fetchTeamPlayers 중복 방지
  var isLoadingLineup: Bool = false  // fetchLineup 중복 방지
  var errorMessage: String?

  var lastUpdated: String = "" {
    didSet {
      print("경기 날짜 변경됨. watch로 전송 시작")
      WatchSessionManager.shared.sendLastUpdated(self.lastUpdated)
    }
  }
  var opponent: String = ""
  var hasGame: Bool = true
  var isSeasonActive: Bool = true
  @MainActor var isRefreshDisabled: Bool = false

  /// 현재 게임 상태
  var gameState: GameState {
    if !isSeasonActive {
      return .noSeason
    } else if !hasGame {
      return .noGame
    } else {
      return .normal
    }
  }

  private var modelContext: ModelContext?

  // MARK: - Initialization

  @MainActor
  func restoreLastLocalLineup(for teamCode: String) async {
    await loadPlayersFromLocal(teamCode: teamCode)
    await loadAllPlayersFromLocal(teamCode: teamCode)
    self.hasGame = true
    self.isSeasonActive = true
    self.isRefreshDisabled = true
  }

  func setModelContext(_ context: ModelContext) {
    self.modelContext = context
  }

  // MARK: - Public Methods
  /// API에서 선수 라인업을 가져오거나 실패 시 로컬 데이터를 조회합니다.
  func fetchLineup(for teamCode: String) async {
    guard !isLoadingLineup else {  // 중복 호출 방지
      return
    }
    await MainActor.run {
      isRefreshDisabled = false
      isLoadingLineup = true
      errorMessage = nil
    }
    defer {
      Task { @MainActor in
        isLoadingLineup = false
      }
    }

    do {
      // 1. 원격 버전 가져오기
      let remoteVersion = try await versionNetworkService.fetchLineupVersion(teamCode: teamCode)

      // 2. 로컬 팀 조회 및 버전 비교
      let searchTeamCode = teamCode.lowercased()
      let descriptor = FetchDescriptor<Team>(
        predicate: #Predicate<Team> { $0.themeRaw == searchTeamCode }
      )

      guard let team = try modelContext?.fetch(descriptor).first else {
        return
      }

      if remoteVersion == team.lineupVersion {
        print("버전 동일")
        await loadPlayersFromLocal(teamCode: teamCode)
        await loadAllPlayersFromLocal(teamCode: teamCode)
      } else {
        print("버전 불일치")
        let response = try await playersNetworkService.fetchLineup(teamCode: teamCode)

        // 로컬 데이터 업데이트
        await updateLineupData(from: response, teamCode: teamCode)

        // 버전 갱신
        await MainActor.run {
          team.lineupVersion = remoteVersion
        }

        // 업데이트 후 로컬 데이터 사용
        await loadPlayersFromLocal(teamCode: teamCode)
        await loadAllPlayersFromLocal(teamCode: teamCode)
      }
    } catch {
      await MainActor.run {
        handleError(error)
        print(error)
      }
      await loadPlayersFromLocal(teamCode: teamCode)
      await loadAllPlayersFromLocal(teamCode: teamCode)
    }
  }

  /// API에서 전체 선수 명단을 가져오거나 실패 시 로컬 데이터를 조회합니다.
  func fetchTeamPlayers(for teamCode: String) async {
    guard !isLoadingPlayers else {  // 중복 호출 방지
      return
    }
    await MainActor.run {
      isLoadingPlayers = true
      errorMessage = nil
    }
    defer {
      Task { @MainActor in
        isLoadingPlayers = false
      }
    }

    do {
      // 1. 원격 버전 가져오기
      let remoteVersion = try await versionNetworkService.fetchTeamPlayerListVersion(
        teamCode: teamCode)

      // 2. 로컬 팀 조회 및 버전 비교
      let searchTeamCode = teamCode.lowercased()
      let descriptor = FetchDescriptor<Team>(
        predicate: #Predicate<Team> { $0.themeRaw == searchTeamCode }
      )

      guard let team = try modelContext?.fetch(descriptor).first else {
        return
      }

      if remoteVersion == team.playersVersion {
        print("버전 동일")
        await loadAllPlayersFromLocal(teamCode: teamCode)
      } else {
        print("버전 불일치")
        let response = try await playersNetworkService.fetchTeamPlayers(teamCode: teamCode)

        // 로컬 데이터 업데이트
        await updateAllPlayersData(from: response, teamCode: teamCode)

        // 버전 갱신
        await MainActor.run {
          team.playersVersion = remoteVersion
        }

        // 업데이트 후 로컬 데이터 사용
        await loadAllPlayersFromLocal(teamCode: teamCode)
      }
    } catch {
      await MainActor.run {
        handleError(error)
      }
      await loadAllPlayersFromLocal(teamCode: teamCode)
    }
  }

  /// 두 선수의 타순을 교환합니다.
  @MainActor
  func swapBattingOrder(playerToBench: Player, playerToStart: Player) async {
    //        print("[SwapBattingOrder] 타순 교환 시작: \(playerToBench.name) <-> \(playerToStart.name)")
    guard let modelContext = self.modelContext else {
      return
    }

    let benchPlayerId = playerToBench.id
    let startPlayerId = playerToStart.id

    // SwiftData에서 최신 선수 객체 가져오기
    var fetchedBenchPlayer: Player?
    var fetchedStartPlayer: Player?

    do {
      var descriptor = FetchDescriptor<Player>(
        predicate: #Predicate { $0.id == benchPlayerId })
      fetchedBenchPlayer = try modelContext.fetch(descriptor).first

      descriptor = FetchDescriptor<Player>(
        predicate: #Predicate { $0.id == startPlayerId })
      fetchedStartPlayer = try modelContext.fetch(descriptor).first
    } catch {
      print("[SwapBattingOrder] 타순 교환 실패: 선수 조회 중 SwiftData 오류 - \(error)")
      return
    }

    guard let benchPlayerInContext = fetchedBenchPlayer else {
      print("[SwapBattingOrder] 타순 교환 실패: 교체 대상 선수(\(benchPlayerId))를 찾을 수 없습니다.")
      return
    }
    guard let startPlayerInContext = fetchedStartPlayer else {
      print("[SwapBattingOrder] 타순 교환 실패 실패: 투입 선수(\(startPlayerId))를 찾을 수 없습니다.")
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
      print("[SwapBattingOrder] 타순 교환 및 저장 완료.")

      // 데이터 리프레시 (UI 업데이트 위해)
      print("[SwapBattingOrder] 선수 목록 데이터 리프레시 시작.")
      let teamCode = ThemeManager.shared.currentTheme.rawValue
      await loadPlayersFromLocal(teamCode: teamCode)
      await loadAllPlayersFromLocal(teamCode: teamCode)
      print("[SwapBattingOrder] 선수 목록 데이터 리프레시 완료.")

    } catch {
      print("[SwapBattingOrder] 실패: SwiftData 저장 중 오류 - \(error)")
      // 오류 발생 시 타순 롤백
      benchPlayerInContext.battingOrder = originalBenchOrder
      startPlayerInContext.battingOrder = originalStartOrder
      print("[SwapBattingOrder] 타순 롤백 완료.")
    }
  }

  // MARK: - Private Methods
  /// 라인업 API 응답으로 로컬 타순, 포지션을 업데이트
  private func updateLineupData(from response: LineupResponse, teamCode: String) async {
    guard let modelContext = self.modelContext else {
      return
    }

    // API 응답에 선수 정보가 없으면 로컬 데이터 업데이트 건너뜀
    guard !response.players.isEmpty else {
      return
    }

    do {
      let searchTeamCode = teamCode.lowercased()
      let descriptor = FetchDescriptor<Team>(
        predicate: #Predicate<Team> {
          $0.themeRaw == searchTeamCode
        }
      )

      if let team = try modelContext.fetch(descriptor).first {
        guard let localPlayers = team.teamMemeberList else {
          print("팀(\(searchTeamCode))의 teamMemeberList가 nil입니다.")
          return
        }

        var updatedCount = 0
        var unmatchedCount = 0

        // API로 받아온 선수들의 정보로 SwiftData 업데이트
        for localPlayer in localPlayers {
          // API에서 받아온 선수 중에서 등번호가 같은 선수를 찾음
          if let apiPlayerDTO = response.players.first(where: {
            Int($0.backNumber) == localPlayer.jerseyNumber
          }) {
            await MainActor.run {
              localPlayer.battingOrder = Int(apiPlayerDTO.batsOrder) ?? 0
              localPlayer.position = [apiPlayerDTO.position, apiPlayerDTO.batsThrows]
                .compactMap { $0 }  // nil 제거
                .joined(separator: ", ")
            }
            updatedCount += 1
          } else {
            await MainActor.run {
              localPlayer.battingOrder = 0
              localPlayer.position = "교체 선수"
            }
            unmatchedCount += 1
          }
        }

        // 마지막 업데이트 정보와 상대팀 정보 업데이트
        team.lastUpdated = response.updated
        team.lastOpponent = response.opponent
        team.hasGame = response.hasGameToday
        team.isSeasonActive = response.isSeasonActive

        // 3. 저장
        try modelContext.save()

        print("- 전체 로컬 선수: \(localPlayers.count)")
        print("- 업데이트된 선수: \(updatedCount)")
        print("- 교체 선수로 변경: \(unmatchedCount)")
        print("마지막 업데이트 정보: \(team.lastUpdated)")
        print("상대팀 업데이트 정보: \(team.lastOpponent)")
      }
    } catch {
      print("SwiftData 로컬 데이터 업데이트 실패: \(error)")
    }
  }

  /// 팀 전체선수명단 API 응답으로 팀 선수명단 업데이트
  private func updateAllPlayersData(from response: [PlayerDTO], teamCode: String) async {
    guard let modelContext = self.modelContext else {
      return
    }
    guard !response.isEmpty else {
      return
    }

    do {
      let searchTeamCode = teamCode.lowercased()
      let descriptor = FetchDescriptor<Team>(
        predicate: #Predicate<Team> { $0.themeRaw == searchTeamCode }
      )

      if let team = try modelContext.fetch(descriptor).first {
        // 1. 기존 선수 목록 초기화
        await MainActor.run {
          // 1. 기존 선수 전부 삭제 (관계+엔티티 동시 삭제)
          if let existing = team.teamMemeberList {
            existing.forEach { modelContext.delete($0) }
            team.teamMemeberList = []
          }

          // 2. API 응답 기반 새 선수 추가
          for dto in response {
            let cheerSongs: [CheerSong] = dto.cheerSongs.map { songDTO in
              CheerSong(
                title: songDTO.title,
                lyrics: songDTO.lyrics,
                audioFileName: songDTO.audioFileName
              )
            }

            let newPlayer = Player(
              cheerSongList: cheerSongs,
              team: team,
              jerseyNumber: Int(dto.backNumber) ?? 0,
              name: dto.name,
              position: [dto.position, dto.batsThrows].compactMap { $0 }.joined(separator: ", "),
              battingOrder: Int(dto.batsOrder) ?? 0
            )

            modelContext.insert(newPlayer)
            team.teamMemeberList?.append(newPlayer)
          }
        }

        // 3. 저장
        try modelContext.save()
        print("전체 선수 명단 업데이트 완료 (총 \(response.count)명)")
      } else {
        print("해당 팀(\(searchTeamCode))을 찾을 수 없음")
      }
    } catch {
      print("전체 선수 명단 업데이트 실패: \(error)")
    }
  }

  /// 로컬 데이터에서 선수 정보를 조회합니다.
  private func loadPlayersFromLocal(teamCode: String) async {
    guard let modelContext = self.modelContext else {
      await MainActor.run {
        self.isLoadingLineup = false
        self.errorMessage = "데이터를 불러올 수 없습니다."
      }
      return
    }

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
          self.opponent = "\(ThemeManager.shared.currentTheme.shortName) vs \(team.lastOpponent)"
          self.hasGame = team.hasGame
          self.isSeasonActive = team.isSeasonActive
          self.isLoadingLineup = false

          // 타순이 0인 선수들을 backupPlayers에 할당
          let benchPlayers = allPlayers.filter { $0.battingOrder == 0 }
          // 이름 순으로 정렬
          self.backupPlayers = benchPlayers.sorted { $0.name < $1.name }

          print("- 전체 선수: \(allPlayers.count)")
          print("- 선발 선수: \(self.players.count)")
          print("- 백업 선수 (backupPlayers, 이름 정렬됨): \(self.backupPlayers.count)")
        }
      } else {
        await MainActor.run {
          self.isLoadingLineup = false
          self.errorMessage = "팀 정보를 찾을 수 없습니다."
        }
      }
    } catch {
      await MainActor.run {
        self.isLoadingLineup = false
        self.errorMessage = "데이터 조회 중 오류가 발생했습니다."
      }
    }
  }

  /// 로컬 데이터에서 모든 선수 정보를 조회하여 allPlayers에 저장합니다.
  private func loadAllPlayersFromLocal(teamCode: String) async {
    guard let modelContext = self.modelContext else {
      return
    }

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
          // 1. 응원가가 있는 선수 우선, 2. 이름 순으로 정렬
          self.allPlayers = localAllPlayers.sorted { p1, p2 in
            let p1HasSong = p1.cheerSongList?.isEmpty == false
            let p2HasSong = p2.cheerSongList?.isEmpty == false

            if p1HasSong != p2HasSong {
              return p1HasSong  // 응원가 있는 선수가 앞으로 (true > false)
            }
            return p1.name < p2.name  // 응원가 유무가 같으면 이름순 정렬
          }
          print("- 전체 선수 (allPlayers): \(self.allPlayers.count)")
        }
      } else {
        print("팀 정보를 찾을 수 없음 (allPlayers)")
      }
    } catch {
      print("로컬 데이터 모든 선수 조회 실패 (allPlayers): \(error)")
    }
  }

  /// DTO를 Player 모델로 변환합니다.
  private func convertToPlayer(from dto: PlayerDTO) -> Player {
    let battingOrder = Int(dto.batsOrder) ?? 0
    let jerseyNumber = Int(dto.backNumber) ?? 0
    let position = [dto.position, dto.batsThrows]
      .compactMap { $0 }  // nil 제거
      .joined(separator: ", ")

    return Player(
      cheerSongList: nil,
      jerseyNumber: jerseyNumber,
      name: dto.name,
      position: position,
      battingOrder: battingOrder
    )
  }

  /// 에러를 처리하고 적절한 에러 메시지를 설정합니다.
  private func handleError(_ error: Error) {
    if let networkError = error as? NetworkError {
      errorMessage = networkError.userMessage
    } else {
      errorMessage = "알 수 없는 오류가 발생했습니다."
    }
  }
}
