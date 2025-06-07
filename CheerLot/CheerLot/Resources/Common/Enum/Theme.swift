//
//  Theme.swift
//  CheerLot
//
//  Created by 이현주 on 5/30/25.
//

import SwiftUI

enum Theme: String, CaseIterable, Identifiable {
  case HH = "hh"
  case LG = "lg"
  case LT = "lt"
  case SS = "ss"
  case NC = "nc"
  case SK = "sk"
  case OB = "ob"
  case KT = "kt"
  case WO = "wo"
  case HT = "ht"

  var id: String { rawValue }
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

  var primaryColor: Color {
    Color("\(self.rawValue)_primary")
  }

  var playerColor: Color {
    Color("\(self.rawValue)_player")
  }

  var buttonColor: Color {
    Color("\(self.rawValue)_button")
  }

  var mainTopViewBackground: Image {
    Image("\(self.rawValue)_mainTopBG")
  }

  var changeTopViewBackground: Image {
    Image("\(self.rawValue)_changeTopBG")
  }

  var shortName: String {
    switch self {
    case .SS: return "삼성"
    case .HH: return "한화"
    case .LG: return "LG"
    case .LT: return "롯데"
    case .NC: return "NC"
    case .SK: return "SK"
    case .OB: return "두산"
    case .KT: return "KT"
    case .WO: return "키움"
    case .HT: return "KIA"
    }
  }

  var cheerSongHatImage: Image {
    Image("\(self.rawValue)_hat")
  }

  var cheerSongBackground: Image {
    Image("\(self.rawValue)_cheerSongBG")
  }
}
