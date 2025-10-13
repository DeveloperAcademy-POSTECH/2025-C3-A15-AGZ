//
//  RemoteConfigChecker.swift
//  CheerLot
//
//  Created by 이현주 on 9/28/25.
//

import FirebaseRemoteConfig
import SwiftUI

final class RemoteConfigChecker: ObservableObject {
  @Published var shouldForceUpdate: Bool = false
  @Published var isServerChecking: Bool = false
  @Published var serverCheckingMessage: String = ""

  private let remoteConfig = RemoteConfig.remoteConfig()

  init() {
    let settings = RemoteConfigSettings()
    settings.minimumFetchInterval = 0
    remoteConfig.configSettings = settings
    remoteConfig.setDefaults([
      "minimum_version": "1.0.0" as NSObject,
      "is_server_check": false as NSObject,
      "server_check_message": "서버 점검 중입니다." as NSObject,
    ])
  }

  func fetchRemoteConfig() async {
    await withCheckedContinuation { continuation in
      remoteConfig.fetchAndActivate { [weak self] _, error in
        guard let self = self else {
          continuation.resume()
          return
        }

        if let error = error {
          continuation.resume()
          return
        }

        self.handleVersionCheck()
        self.handleServerChecking()
        continuation.resume()
      }
    }
  }

  private func handleVersionCheck() {
    let minVersion = remoteConfig["minimum_version"].stringValue
    let currentVersion =
      Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "0"

    print("최소 지원 버전: \(minVersion), 현재 버전: \(currentVersion)")

    if isUpdateRequired(current: currentVersion, minimum: minVersion) {
      DispatchQueue.main.async {
        self.shouldForceUpdate = true
      }
    }
  }

  private func handleServerChecking() {
    let isServerChecking = remoteConfig["is_server_check"].boolValue
    let message = remoteConfig["server_check_message"].stringValue

    DispatchQueue.main.async {
      self.isServerChecking = isServerChecking
      self.serverCheckingMessage = message
    }
  }

  private func isUpdateRequired(current: String, minimum: String) -> Bool {
    let currentComponents = current.split(separator: ".").compactMap { Int($0) }
    let minimumComponents = minimum.split(separator: ".").compactMap { Int($0) }

    for (c, m) in zip(currentComponents, minimumComponents) {
      if c < m { return true }
      if c > m { return false }
    }
    return currentComponents.count < minimumComponents.count
  }
}
