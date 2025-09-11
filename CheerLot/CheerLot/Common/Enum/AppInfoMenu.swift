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
  case copyright = "저작권 법적고지"
  case reportBug = "문의하기"
  case aboutMaker = "쳐랏을 만든 사람들"

  var id: String { self.rawValue }

  var route: NavigationDestination? {
    switch self {
    case .termsOfService: return .termsOfService
    case .privacyPolicy: return .privacyPolicy
    case .copyright: return .copyright
    case .reportBug: return nil
    case .aboutMaker: return .aboutMaker
    }
  }
}
