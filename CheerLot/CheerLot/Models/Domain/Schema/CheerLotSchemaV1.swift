//
//  CheerLotSchemaV1.swift
//  CheerLot
//
//  Created by 이현주 on 9/28/25.
//

import Foundation
import SwiftData

enum CheerLotSchemaV1: VersionedSchema {
  static var models: [any PersistentModel.Type] {
    [Team.self, Player.self, CheerSong.self]
  }

  static var versionIdentifier = Schema.Version(1, 0, 0)

  @Model
  final class Team {
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

  @Model
  final class Player: Hashable {
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

  @Model
  final class CheerSong: Hashable {
    var title: String
    var lyrics: String
    var audioFileName: String  // 음원 파일 자체 이름 (확장자까지)
    @Relationship var player: Player?

    init(title: String, lyrics: String, audioFileName: String, player: Player? = nil) {
      self.title = title
      self.lyrics = lyrics
      self.audioFileName = audioFileName
      self.player = player
    }
  }
}
