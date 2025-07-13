//
//  ThemeManager.swift
//  CheerLot
//
//  Created by 이현주 on 6/11/25.
//

import FirebaseAnalytics
import Foundation
import SwiftUI

#if os(iOS)
  import UIKit
#endif

final class ThemeManager: ObservableObject {
  static let shared = ThemeManager()

  private let themeKey = "selectedTheme"
  @AppStorage("selectedTheme") private var themeRaw: String?

  // 현재 테마 변수
  var currentTheme: Theme {
    get {
      guard let raw = themeRaw, let theme = Theme(rawValue: raw) else {
        return .SS  // 기본값
      }
      return theme
    }
    set {
      themeRaw = newValue.rawValue
      Analytics.setUserProperty(newValue.rawValue, forName: "team_theme")
      #if os(iOS)
        updateAppIcon(for: newValue)
      #endif
    }
  }

  // 테마 변경 메서드
  func updateTheme(_ theme: Theme) {
    themeRaw = theme.rawValue
    WatchSessionManager.shared.sendTheme(theme)
    Analytics.setUserProperty(theme.rawValue, forName: "team_theme")
    #if os(iOS)
      updateAppIcon(for: theme)
    #endif
  }

  // 테마 선택 여부 변수
  var isThemeInitialized: Bool {
    return themeRaw != nil
  }

  #if os(iOS)
    private func updateAppIcon(for theme: Theme) {
      guard UIApplication.shared.supportsAlternateIcons else {
        print("⚠️ 앱 아이콘 변경 지원 안함")
        return
      }

      let appIcon = AppIcon.from(theme: theme)

      if let appIconName = appIcon.iconName {
        let iconName = appIconName
        let currentIcon = UIApplication.shared.alternateIconName

        if currentIcon != iconName {
          UIApplication.shared.setAlternateIconName(iconName) { error in
            if let error = error {
              print("❌ 아이콘 변경 실패:", error)
              print(iconName)
            } else {
              print("✅ 아이콘 변경 성공: \(iconName)")
            }
          }
        } else {
          print("ℹ️ 현재와 같은 아이콘. 변경 생략됨")
        }
      }
    }
  #endif
}
