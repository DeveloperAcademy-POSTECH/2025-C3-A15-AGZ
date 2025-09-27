//
//  APITargetType.swift
//  CheerLot
//
//  Created by 이현주 on 9/23/25.
//

import Foundation
import Moya

protocol APITargetType: TargetType {}

extension APITargetType {
  var baseURL: URL {
    return URL(string: Config.apiURL)!
  }

  var headers: [String: String]? {
    return ["Content-Type": "application/json"]
  }

  var sampleData: Data {
    return Data()
  }
}
