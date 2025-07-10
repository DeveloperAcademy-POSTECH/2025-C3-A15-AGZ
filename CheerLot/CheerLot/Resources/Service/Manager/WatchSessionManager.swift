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

  private override init() {
    super.init()
    if WCSession.isSupported() {
      session.delegate = self
      session.activate()
    }
  }

  private let session = WCSession.default

  // 테마 전송
  func sendTheme(_ theme: Theme) {
    if session.isPaired && session.isWatchAppInstalled {
      let userInfo: [String: Any] = ["Theme": theme.rawValue]
      session.transferUserInfo(userInfo)
    }
  }

  // 선수 리스트 전송
  func sendPlayerList(_ players: [PlayerWatchDto]) {
    if session.isPaired && session.isWatchAppInstalled {
      do {
        let encoded = try JSONEncoder().encode(players)
        print("watch 전송 데이터 크기: \(encoded.count) bytes")
        session.transferUserInfo(["players": encoded])
      } catch {
        print("인코딩 실패: \(error)")
      }
    }
  }

  // 업데이트 날짜 전송
  func sendLastUpdated(_ date: String) {
    if session.isPaired && session.isWatchAppInstalled {
      let userInfo: [String: Any] = ["Date": date]
      session.transferUserInfo(userInfo)
    }
  }

  // MARK: - WCSessionDelegate 필수 구현
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
