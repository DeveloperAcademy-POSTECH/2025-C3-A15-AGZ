//
//  VersionChecker.swift
//  CheerLot
//
//  Created by 이현주 on 9/28/25.
//

import FirebaseRemoteConfig
import SwiftUI

final class VersionChecker: ObservableObject {
  @Published var shouldForceUpdate: Bool = false
  private let remoteConfig = RemoteConfig.remoteConfig()

  init() {
    let settings = RemoteConfigSettings()
    settings.minimumFetchInterval = 0
    remoteConfig.configSettings = settings
    remoteConfig.setDefaults(["minimum_version": "1.0.0" as NSObject])
  }

  func checkAppVersion() async {
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

        let minVersion = self.remoteConfig["minimum_version"].stringValue
        let currentVersion =
          Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "0"

        print("최소 지원 버전: \(minVersion), 현재 버전: \(currentVersion)")

        if self.isUpdateRequired(current: currentVersion, minimum: minVersion) {
          DispatchQueue.main.async {
            self.shouldForceUpdate = true
          }
        }
        continuation.resume()
      }
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
