//
//  Player.swift
//  CheerLot
//
//  Created by 이현주 on 5/30/25.
//

import SwiftData
import SwiftUI

@Model
class Player: Hashable {
  @Relationship(deleteRule: .cascade, inverse: \CheerSong.player) var cheerSongList: [CheerSong]?
  @Relationship var team: Team?
  @Attribute(.unique) var id: String
  var jerseyNumber: Int
  var name: String
  var position: String
  var battingOrder: Int

  init(
    cheerSongList: [CheerSong]? = nil,
    team: Team? = nil,
    jerseyNumber: Int,
    name: String,
    position: String,
    battingOrder: Int
  ) {
    self.cheerSongList = cheerSongList
    self.team = team
    self.jerseyNumber = jerseyNumber
    self.name = name
    self.position = position
    self.battingOrder = battingOrder

    // 팀코드 + 등번호로 id 생성
    let teamCode = team?.themeRaw ?? "UNKNOWN"
    self.id = "\(teamCode.uppercased())\(jerseyNumber)"
  }
}
