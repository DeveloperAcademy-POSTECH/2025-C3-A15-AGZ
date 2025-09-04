//
//  PlayerWatchDto.swift
//  CheerLot
//
//  Created by 이현주 on 6/3/25.
//

import Foundation

struct PlayerWatchDto: Codable, Hashable {
  var cheerSongList: [CheerSongWatchDto]
  var id: String
  var jerseyNumber: Int
  var name: String
  var position: String
  var battingOrder: Int
}

struct CheerSongWatchDto: Codable, Hashable {
  var title: String
  var lyrics: String
  var audioFileName: String
}
