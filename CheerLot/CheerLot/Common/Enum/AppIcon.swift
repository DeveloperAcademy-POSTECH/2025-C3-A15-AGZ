//
//  AppIcon.swift
//  CheerLot
//
//  Created by 이승진 on 6/12/25.
//

import Foundation

enum AppIcon: String, CaseIterable {
  case `default` = "AppIcon"
  case ss = "AppIcon_ss"
  case nc = "AppIcon_nc"
  case wo = "AppIcon_wo"
  case hh = "AppIcon_hh"
  case lg = "AppIcon_lg"
  case ht = "AppIcon_ht"
  case sk = "AppIcon_sk"
  case lt = "AppIcon_lt"
  case kt = "AppIcon_kt"
  case ob = "AppIcon_ob"

  var iconName: String? {
    return self == .default ? nil : rawValue
  }

  static func from(theme: Theme) -> AppIcon {
    switch theme {
    case .SS: return .ss
    case .NC: return .nc
    case .WO: return .wo
    case .HH: return .hh
    case .LG: return .lg
    case .HT: return .ht
    case .SK: return .sk
    case .LT: return .lt
    case .KT: return .kt
    case .OB: return .ob
    }
  }
}
