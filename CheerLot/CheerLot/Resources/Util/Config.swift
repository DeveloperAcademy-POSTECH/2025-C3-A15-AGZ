//
//  Config.swift
//  CheerLot
//
//  Created by 이현주 on 5/29/25.
//

import Foundation

enum Config {
  private static let infoDictionary: [String: Any] = {
    guard let dict = Bundle.main.infoDictionary else {
      fatalError("Plist 없음")
    }
    return dict
  }()

  static let apiURL: String = {
    guard let apiURL = infoDictionary["API_URL"] as? String else {
      fatalError()
    }
    return apiURL
  }()
}
