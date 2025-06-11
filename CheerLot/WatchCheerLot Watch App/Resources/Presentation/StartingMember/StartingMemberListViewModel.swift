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
    
  var session: WCSession
  var players: [PlayerWatchDto] = []
  var lastUpdatedDate: String = ""
    
    private let themeKey = "watchSelectedTheme"

      var currentTheme: Theme {
        get {
          let raw = UserDefaults.standard.string(forKey: themeKey)
          return Theme(rawValue: raw ?? "") ?? .OB
        }
        set {
          UserDefaults.standard.set(newValue.rawValue, forKey: themeKey)
        }
      }

  init(session: WCSession = .default) {
    self.session = session
    super.init()
    session.delegate = self
    session.activate()
  }

  func session(
    _ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState,
    error: Error?
  ) {
    print("session 활성화 완료: \(activationState)")
  }

  // 다른 기기의 세션으로부터 transferUserInfo() 메서드로 데이터를 받았을 때 호출되는 메서드
    func session(_ session: WCSession, didReceiveUserInfo userInfo: [String: Any] = [:]) {
        print("앱에서 온 데이터 수신 시작")
        DispatchQueue.main.async {
            if let themeRaw = userInfo["Theme"] as? String,
               let theme = Theme(rawValue: themeRaw),
               theme != self.currentTheme {
                self.currentTheme = theme
            }

            if let newDate = userInfo["Date"] as? String,
               newDate != self.lastUpdatedDate {
                self.lastUpdatedDate = newDate
            }

            
            if let dataArray = userInfo["players"] as? Data {
                do {
                    let decoded = try JSONDecoder().decode([PlayerWatchDto].self, from: dataArray)
                    self.players = decoded
                    print("플레이어 수신 성공: \(decoded.count)")
                } catch {
                    print("decoding error: \(error)")
                }
            } else {
                print("userInfo에서 데이터 추출 실패")
            }
        }
    }
}
