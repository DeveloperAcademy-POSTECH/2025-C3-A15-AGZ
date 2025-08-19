//
//  LineupResponse.swift
//  CheerLot
//
//  Created by theo on 6/2/25.
//

// MARK: 엔티티 같은 친구인데, DTO라는 네이밍은 적절하지 않은 것 같음
struct LineupResponse: Codable {
  let updated: String
  let opponent: String
  let players: [PlayerDTO]
}

struct PlayerDTO: Codable {
  let id: Int
  let name: String
  let backNumber: String
  let position: String
  let batsThrows: String
  let batsOrder: String
  let team: TeamDTO
}

struct TeamDTO: Codable {
  let teamCode: String
  let name: String
  let lastUpdated: String
  let lastOpponent: String
}
