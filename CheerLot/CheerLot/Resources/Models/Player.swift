//
//  Player.swift
//  CheerLot
//
//  Created by 이현주 on 5/30/25.
//

import SwiftData
import SwiftUI

@Model
class Player {
  @Relationship(deleteRule: .cascade) var cheerSongList: [CheerSong]?
  @Attribute(.unique) var id: Int
  var name: String
  var position: String
  var battingOrder: Int

  init(
    cheerSongList: [CheerSong]? = nil, id: Int, name: String, position: String, battingOrder: Int
  ) {
    self.cheerSongList = cheerSongList
    self.id = id
    self.name = name
    self.position = position
    self.battingOrder = battingOrder
  }
}
