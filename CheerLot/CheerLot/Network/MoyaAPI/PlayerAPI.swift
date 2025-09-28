//
//  LineupAPI.swift
//  CheerLot
//
//  Created by theo on 6/2/25.
//

import Foundation
import Moya

enum PlayerAPI {
  case getLineup(teamCode: String)
  case getPlayers(teamCode: String)
}

extension PlayerAPI: APITargetType {
  var path: String {
    switch self {
    case .getLineup(let teamCode):
      return "/lineups/\(teamCode)"
    case .getPlayers(let teamCode):
      return "/players/\(teamCode)"
    }
  }

  var method: Moya.Method {
    switch self {
    case .getLineup, .getPlayers:
      return .get
    }
  }

  var task: Task {
    switch self {
    case .getLineup, .getPlayers:
      return .requestPlain
    }
  }
}
