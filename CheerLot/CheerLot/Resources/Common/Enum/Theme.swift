//
//  Theme.swift
//  CheerLot
//
//  Created by 이현주 on 5/30/25.
//

import SwiftUI

enum Theme: String, CaseIterable {
  case HH
  case LG
  case LT
  case SS
  case NC
  case SK
  case OB
  case KT
  case WO
  case HT
}

extension Theme {
  var teamFullEngName: String {
    switch self {
    case .HH: return ""
    case .LG: return ""
    case .LT: return ""
    case .SS: return "SAMSUNG\nLIONS"
    case .NC: return ""
    case .SK: return ""
    case .OB: return ""
    case .KT: return ""
    case .WO: return ""
    case .HT: return ""
    }
  }

  var teamSlogan: String {
    switch self {
    case .HH: return ""
    case .LG: return ""
    case .LT: return ""
    case .SS: return "WIN or WOW!"
    case .NC: return ""
    case .SK: return ""
    case .OB: return ""
    case .KT: return ""
    case .WO: return ""
    case .HT: return ""
    }
  }
}
