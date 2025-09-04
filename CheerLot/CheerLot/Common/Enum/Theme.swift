//
//  Theme.swift
//  CheerLot
//
//  Created by 이현주 on 5/30/25.
//

import SwiftUI

enum Theme: String, CaseIterable, Identifiable {
  case OB = "ob"
  case HH = "hh"
  case HT = "ht"
  case WO = "wo"
  case KT = "kt"
  case LG = "lg"
  case LT = "lt"
  case NC = "nc"
  case SS = "ss"
  case SK = "sk"

  var id: String { rawValue }
}

extension Theme {
  var teamFullEngName: String {
    switch self {
    case .OB: return "doosan\nbears"
    case .HH: return "hanwha\neagles"
    case .HT: return "kia\ntigers"
    case .WO: return "kiwoom\nheroes"
    case .KT: return "kt\nwiz"
    case .LG: return "lg\ntwins"
    case .LT: return "lotte\ngiants"
    case .NC: return "nc\ndinos"
    case .SS: return "samsung\nlions"
    case .SK: return "ssg\nlanders"
    }
  }

  var teamSlogan: String {
    switch self {
    case .OB: return "HUSTLE DOOGETHER"
    case .HH: return "RIDE THE STORM"
    case .HT: return "압도하라! V13 ALWAYS"
    case .WO: return "도약 영웅의 서막"
    case .KT: return "UP! GREAT KT"
    case .LG: return "무적 LG! 끝까지 TWINS!"
    case .LT: return "투혼투지! 승리를 위한 전진"
    case .NC: return "거침없이 가자 LIGHT, NOW!"
    case .SS: return "WIN or WOW!"
    case .SK: return "NO LIMITS, AMAZING LANDERS"
    }
  }

  var primaryColor01: Color {
    Color("\(self.rawValue)_primary01")
  }

  var primaryColor02: Color {
    Color("\(self.rawValue)_primary02")
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
    case .SK: return "SSG"
    case .OB: return "두산"
    case .KT: return "KT"
    case .WO: return "키움"
    case .HT: return "KIA"
    }
  }

  var longName: String {
    switch self {
    case .SS: return "삼성 라이온즈"
    case .HH: return "한화 이글스"
    case .LG: return "LG 트윈스"
    case .LT: return "롯데 자이언츠"
    case .NC: return "NC 다이노스"
    case .SK: return "SSG 랜더스"
    case .OB: return "두산 베어스"
    case .KT: return "KT 위즈 "
    case .WO: return "키움 히어로즈"
    case .HT: return "기아 타이거즈"
    }
  }

  var cheerSongHatImage: Image {
    Image("\(self.rawValue)_hat")
  }

  var cheerSongBackground: Image {
    Image("\(self.rawValue)_cheerSongBG")
  }

  var watchListBackground: Image {
    Image("\(self.rawValue)_listBG")
  }
}
