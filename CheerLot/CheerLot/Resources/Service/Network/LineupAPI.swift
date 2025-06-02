//
//  LineupAPI.swift
//  CheerLot
//
//  Created by theo on 6/2/25.
//

import Foundation
import Moya

enum LineupAPI {
    case getLineup(teamCode: String)
}

extension LineupAPI: TargetType {
    var baseURL: URL {
        return URL(string: "http://43.201.20.198:8080/api")!
    }
    
    var path: String {
        switch self {
        case .getLineup(let teamCode):
            return "/lineups/\(teamCode)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getLineup:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .getLineup:
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