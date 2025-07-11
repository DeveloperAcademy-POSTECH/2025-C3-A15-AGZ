//
//  WatchSessionManager.swift
//  CheerLot
//
//  Created by 이현주 on 6/12/25.
//

import SwiftUI
import WatchConnectivity

final class WatchSessionManager: NSObject, WCSessionDelegate {

  static let shared = WatchSessionManager()
  private let session = WCSession.default

  private override init() {
    super.init()
    guard WCSession.isSupported() else { return }
    session.delegate = self
    session.activate()
  }

  // 테마 전송
  func sendTheme(_ theme: Theme) {
    guard session.isPaired, session.isWatchAppInstalled else { return }
    updateContext(["Theme": theme.rawValue])
  }

  // 선수 리스트 전송
  func sendPlayerList(_ players: [PlayerWatchDto]) {
    guard session.isPaired, session.isWatchAppInstalled else { return }
    guard let data = try? JSONEncoder().encode(players) else {
      print("Player 인코딩 실패")
      return
    }
    updateContext(["players": data])
  }

  // 업데이트 날짜 전송
  func sendLastUpdated(_ date: String) {
    guard session.isPaired, session.isWatchAppInstalled else { return }
    updateContext(["Date": date])
  }

  private func updateContext(_ context: [String: Any]) {
    do {
      try session.updateApplicationContext(context)
    } catch {
      print("updateApplicationContext 실패: \(error.localizedDescription)")
    }
  }

  // MARK: - WCSessionDelegate 필수 구현
  func session(
    _ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState,
    error: Error?
  ) {
    guard activationState == .activated else { return }
    // 테마
    sendTheme(ThemeManager.shared.currentTheme)
    // 선발 선수 명단
    let rosterVM = TeamRoasterViewModel.shared
    let playerDTOs = rosterVM.players.map { player in
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
    sendPlayerList(playerDTOs)
    // 대진 날짜
    sendLastUpdated(rosterVM.lastUpdated)

  }

  func sessionDidBecomeInactive(_ session: WCSession) {

  }

  func sessionDidDeactivate(_ session: WCSession) {

  }
}
