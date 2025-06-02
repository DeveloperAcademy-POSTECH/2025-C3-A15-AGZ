//
//  LineupResponse.swift
//  CheerLot
//
//  Created by theo on 6/2/25.
//

struct LineupResponse: Codable {
    let updated: String
    let opponent: String
    let players: [PlayerDTO]
    
    enum CodingKeys: String, CodingKey {
        case updated = "updated"
        case opponent = "Opponent"
        case players
    }
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
