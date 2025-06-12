//
//  ThemeManager.swift
//  CheerLot
//
//  Created by 이현주 on 6/11/25.
//

import Foundation
import SwiftUI

final class ThemeManager: ObservableObject {
  static let shared = ThemeManager()

  private let suiteName = "group.com.ivylee.CheerLot"
  private let themeKey = "selectedTheme"
  @AppStorage("selectedTheme", store: UserDefaults(suiteName: "group.com.ivylee.CheerLot")) private
    var themeRaw: String?

  // 현재 테마 변수
  var currentTheme: Theme {
    get {
      guard let raw = themeRaw, let theme = Theme(rawValue: raw) else {
        return .SS  // 기본값
      }
      return theme
    }
    set { themeRaw = newValue.rawValue }
  }

  // 테마 변경 메서드
  func updateTheme(_ theme: Theme) {
    themeRaw = theme.rawValue
    WatchSessionManager.shared.sendTheme(theme)
  }

  // 테마 선택 여부 변수
  var isThemeInitialized: Bool {
    return themeRaw != nil
  }
}
