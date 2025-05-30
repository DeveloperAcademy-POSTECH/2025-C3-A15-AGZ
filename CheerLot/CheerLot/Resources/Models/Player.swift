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
  @Relationship(deleteRule: .cascade) var CheerSongList: [CheerSong]?
  @Attribute(.unique) var id: Int
  var name: Int
  var position: String
  var battingOrder: Int

  init(CheerSongList: [CheerSong]? = nil, id: Int, name: Int, position: String, battingOrder: Int) {
    self.CheerSongList = CheerSongList
    self.id = id
    self.name = name
    self.position = position
    self.battingOrder = battingOrder
  }
}
