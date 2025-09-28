//
//  LineupResponse.swift
//  CheerLot
//
//  Created by theo on 6/2/25.
//

struct LineupResponse: Codable {
  let updated: String
  let opponent: String
  let hasGameToday: Bool
  let isSeasonActive: Bool
  let players: [PlayerDTO]
}

struct PlayerDTO: Codable {
  let playerId: String
  let name: String
  let backNumber: String
  let position: String
  let batsThrows: String?
  let batsOrder: String
  let teamCode: String
  let cheerSongs: [CheerSongDTO]
}

struct CheerSongDTO: Codable {
  let id: String
  let title: String
  let lyrics: String
  let audioFileName: String
  let playerId: String
}
