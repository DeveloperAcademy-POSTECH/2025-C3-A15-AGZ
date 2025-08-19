//
//  NetworkService.swift
//  CheerLot
//
//  Created by theo on 6/2/25.
//

import Foundation
import Moya

// MARK: Moya를 써서 더 복잡해졌음ㅜ -루미-
class LineupNetworkService {
  private let provider = MoyaProvider<LineupAPI>()

  func fetchLineup(teamCode: String) async throws -> LineupResponse {
    return try await withCheckedThrowingContinuation { continuation in
      provider.request(.getLineup(teamCode: teamCode)) { result in
        switch result {
        case .success(let response):
          do {
            let lineupResponse = try JSONDecoder().decode(LineupResponse.self, from: response.data)
            continuation.resume(returning: lineupResponse)
          } catch {
            continuation.resume(throwing: NetworkError.decodingError(error))
          }
        case .failure(let error):
          continuation.resume(throwing: NetworkError.moyaError(error))
        }
      }
    }
  }
}

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
