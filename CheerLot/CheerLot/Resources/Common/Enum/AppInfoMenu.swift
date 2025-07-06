//
//  AppInfoMenu.swift
//  CheerLot
//
//  Created by 이현주 on 7/6/25.
//

import SwiftUI

enum AppInfoMenu: String, CaseIterable, Identifiable {
    case termsOfService = "이용약관"
    case privacyPolicy = "개인정보 처리방침"
    case copyright = "저작권 약관"
    case reportBug = "버그 신고"
    case aboutMaker = "만든 사람들"

    var id: String { self.rawValue }

    var route: MainRoute {
        switch self {
        case .termsOfService: return .termsOfService
        case .privacyPolicy: return .privacyPolicy
        case .copyright: return .copyright
        case .reportBug: return .reportBug
        case .aboutMaker: return .aboutMaker
        }
    }
}
