//
//  NetworkError.swift
//  CheerLot
//
//  Created by 이현주 on 9/23/25.
//

import Foundation
import Moya

enum NetworkError: Error {
  case decodingError(Error)
  case moyaError(MoyaError)

  var localizedDescription: String {
    switch self {
    case .decodingError(let error):
      return "데이터 파싱 실패: \(error.localizedDescription)"
    case .moyaError(let error):
      return "네트워크 요청 실패: \(error.localizedDescription)"
    }
  }
}
