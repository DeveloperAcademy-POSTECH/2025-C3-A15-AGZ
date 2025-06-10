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

    private let themeKey = "selectedTheme"
    @AppStorage("selectedTheme") private var themeRaw: String?

    var currentTheme: Theme {
        get {
            guard let raw = themeRaw, let theme = Theme(rawValue: raw) else {
                return .SS  // 기본값
            }
            return theme
        }
        set { themeRaw = newValue.rawValue }
    }

    func updateTheme(_ theme: Theme) {
        themeRaw = theme.rawValue
    }
}
