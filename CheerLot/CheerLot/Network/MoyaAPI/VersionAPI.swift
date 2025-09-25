//
//  VersionAPI.swift
//  CheerLot
//
//  Created by 이현주 on 9/23/25.
//

import Foundation
import Moya

enum VersionAPI {
  case getTeamPlayerListVersion(teamCode: String)
  case getLineupVersion(teamCode: String)
}

extension VersionAPI: APITargetType {
  var path: String {
    switch self {
    case .getTeamPlayerListVersion(let teamCode):
      return "/version/roster/\(teamCode)/number"
    case .getLineupVersion(let teamCode):
      return "/version/lineup/\(teamCode)/number"
    }
  }

  var method: Moya.Method {
    switch self {
    case .getTeamPlayerListVersion, .getLineupVersion:
      return .get
    }
  }

  var task: Task {
    switch self {
    case .getTeamPlayerListVersion, .getLineupVersion:
      return .requestPlain
    }
  }
}
