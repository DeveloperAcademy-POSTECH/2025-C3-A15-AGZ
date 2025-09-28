//
//  VersionNetworkService.swift
//  CheerLot
//
//  Created by 이현주 on 9/23/25.
//

import Foundation
import Moya

class VersionNetworkService {
  private let provider = MoyaProvider<VersionAPI>()

  func fetchLineupVersion(teamCode: String) async throws -> Int {
    return try await withCheckedThrowingContinuation { continuation in
      provider.request(.getLineupVersion(teamCode: teamCode)) { result in
        switch result {
        case .success(let response):
          do {
            let versionResponse = try JSONDecoder().decode(Int.self, from: response.data)
            continuation.resume(returning: versionResponse)
          } catch {
            continuation.resume(throwing: NetworkError.decodingError(error))
          }
        case .failure(let error):
          continuation.resume(throwing: NetworkError.moyaError(error, api: .version))
        }
      }
    }
  }

  func fetchTeamPlayerListVersion(teamCode: String) async throws -> Int {
    return try await withCheckedThrowingContinuation { continuation in
      provider.request(.getTeamPlayerListVersion(teamCode: teamCode)) { result in
        switch result {
        case .success(let response):
          do {
            let versionResponse = try JSONDecoder().decode(Int.self, from: response.data)
            continuation.resume(returning: versionResponse)
          } catch {
            continuation.resume(throwing: NetworkError.decodingError(error))
          }
        case .failure(let error):
          continuation.resume(throwing: NetworkError.moyaError(error, api: .version))
        }
      }
    }
  }
}
