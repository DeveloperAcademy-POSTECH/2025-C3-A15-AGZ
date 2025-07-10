//
//  AboutMakerInfo.swift
//  CheerLot
//
//  Created by 이현주 on 7/10/25.
//

import SwiftUI

enum AboutMakerInfo: String, CaseIterable, Identifiable {
  case instagram = "쳐랏 인스타그램"
  case goToReview = "개발자 응원하기"

  var id: String { self.rawValue }

  var url: String {
    switch self {
    case .instagram: return Constants.instagramURL
    case .goToReview: return Constants.appStoreURL
    }
  }
}
