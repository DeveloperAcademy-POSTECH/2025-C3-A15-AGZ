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

extension PlayerAPI: TargetType {
  var baseURL: URL {
    return URL(string: Config.apiURL)!
  }

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
    case .getLineup:
      return .get
    case .getPlayers:
      return .get
    }
  }

  var task: Task {
    switch self {
    case .getLineup:
      return .requestPlain
    case .getPlayers:
      return .requestPlain
    }
  }

  var headers: [String: String]? {
    return ["Content-Type": "application/json"]
  }

  var sampleData: Data {
    return Data()
  }
}
