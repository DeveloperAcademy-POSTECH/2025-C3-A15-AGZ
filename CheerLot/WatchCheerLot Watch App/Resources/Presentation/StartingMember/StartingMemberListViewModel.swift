//
//  StartingMemberListViewModel.swift
//  WatchCheerLot Watch App
//
//  Created by 이현주 on 6/3/25.
//

import Foundation
import Observation
import WatchConnectivity

@Observable
class StartingMemberListViewModel: NSObject, WCSessionDelegate {

  private let session: WCSession
  private let themeKey = "watchSelectedTheme"
  private var activationStateObservation: NSKeyValueObservation?

  var players: [PlayerWatchDto] = []
  var lastUpdatedDate: String = ""

  var currentTheme: Theme {
    get {
      let raw = UserDefaults.standard.string(forKey: themeKey)
      return Theme(rawValue: raw ?? "") ?? .OB
    }
    set {
      UserDefaults.standard.set(newValue.rawValue, forKey: themeKey)
    }
  }

  override init() {
    self.session = .default
    super.init()
    session.delegate = self
    session.activate()
    activationStateObservation = session.observe(\.activationState) { [weak self] session, _ in
      if session.activationState == .activated {
        DispatchQueue.main.async { self?.processContext(session.receivedApplicationContext) }
      }
    }
  }

  deinit {
    activationStateObservation = nil
  }

  private func processContext(_ applicationContext: [String: Any]) {
    if let rawTheme = applicationContext["Theme"] as? String,
      let theme = Theme(rawValue: rawTheme)
    {
      self.currentTheme = theme
    }

    if let newDate = applicationContext["Date"] as? String {
      self.lastUpdatedDate = newDate
    }

    if let data = applicationContext["players"] as? Data {
      do {
        self.players = try JSONDecoder().decode([PlayerWatchDto].self, from: data)
        print("선수 수신 완료 (초기 context): \(players.count)명")
      } catch {
        print("선수 디코딩 실패 (초기 context): \(error.localizedDescription)")
      }
    }
  }

  func session(
    _ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState,
    error: Error?
  ) {
    print("session 활성화 완료: \(activationState)")
    // 최신 applicationContext를 수동으로 가져옴
    let context = session.receivedApplicationContext
    DispatchQueue.main.async {
      self.processContext(context)
    }
  }

  // 다른 기기의 세션으로부터 updateApplicationContext로 데이터를 받았을 때 호출되는 메서드
  func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String: Any])
  {
    DispatchQueue.main.async {
      self.processContext(applicationContext)
    }
  }
}
