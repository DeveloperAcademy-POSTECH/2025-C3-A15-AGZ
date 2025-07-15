//
//  MemberListMenuSegment.swift
//  CheerLot
//
//  Created by 이현주 on 5/31/25.
//

import SwiftUI

enum MemberListMenuSegment: Int, CaseIterable, Identifiable {
  case starting
  case team

  var id: Int { rawValue }

  var title: String {
    switch self {
    case .starting:
      return "선발 선수"
    case .team:
      return "전체 선수"
    }
  }
}
