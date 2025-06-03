//
//  TeamsData.swift
//  CheerLot
//
//  Created by theo on 6/2/25.
//

import Foundation

struct TeamsData: Codable {
  let teams: [TeamData]
}

struct TeamData: Codable {
  let teamCode: String
  let name: String
  let lastUpdated: String
  let lastOpponent: String
  let players: [PlayerData]
}

struct PlayerData: Codable {
  let id: Int
  let name: String
  let position: String?
  let battingOrder: Int
  let cheerSongs: [CheerSongData]
}

struct CheerSongData: Codable {
  let title: String
  let lyrics: String
  let audioFileName: String
}
