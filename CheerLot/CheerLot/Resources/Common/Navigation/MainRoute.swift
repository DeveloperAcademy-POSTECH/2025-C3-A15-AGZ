//
//  MainRoute.swift
//  CheerLot
//
//  Created by 이현주 on 6/1/25.
//

import Foundation

enum MainRoute: Hashable {
  case changeMemeber(selectedPlayer: Player)
//  case playCheerSong(selectedPlayer: Player)
    case playCheerSong(players: [Player], startIndex: Int)
}
