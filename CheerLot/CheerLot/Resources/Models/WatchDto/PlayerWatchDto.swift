//
//  PlayerWatchDto.swift
//  CheerLot
//
//  Created by 이현주 on 6/3/25.
//

import Foundation

// MARK: 엔티티 같은 친구인데, DTO라는 네이밍은 적절하지 않은 것 같음
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
