//
//  Team.swift
//  CheerLot
//
//  Created by 이현주 on 5/30/25.
//

import SwiftData
import SwiftUI

@Model
class Team {
  @Attribute(.unique) var themeRaw: String  //swiftData에 저장될 Theme String

  var theme: Theme {
    get { Theme(rawValue: themeRaw) ?? .SS }
    set { themeRaw = newValue.rawValue }
  }

  @Relationship(deleteRule: .cascade, inverse: \Player.team) var teamMemeberList: [Player]?
  var lastUpdated: String
  var lastOpponent: String

  init(
    themeRaw: String, teamMemeberList: [Player]? = nil, lastUpdated: String, lastOpponent: String
  ) {
    self.themeRaw = themeRaw
    self.teamMemeberList = teamMemeberList
    self.lastUpdated = lastUpdated
    self.lastOpponent = lastOpponent
  }
}
