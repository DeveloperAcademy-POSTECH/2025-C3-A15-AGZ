//
//  PlayersNetworkService.swift
//  CheerLot
//
//  Created by 이현주 on 9/23/25.
//

import Foundation
import Moya

class PlayersNetworkService {
  private let provider = MoyaProvider<PlayerAPI>()

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
          continuation.resume(throwing: NetworkError.moyaError(error, api: .lineup))
        }
      }
    }
  }

  func fetchTeamPlayers(teamCode: String) async throws -> [PlayerDTO] {
    return try await withCheckedThrowingContinuation { continuation in
      provider.request(.getPlayers(teamCode: teamCode)) { result in
        switch result {
        case .success(let response):
          do {
            let playersResponse = try JSONDecoder().decode([PlayerDTO].self, from: response.data)
            continuation.resume(returning: playersResponse)
          } catch {
            continuation.resume(throwing: NetworkError.decodingError(error))
          }
        case .failure(let error):
          continuation.resume(throwing: NetworkError.moyaError(error, api: .players))
        }
      }
    }
  }
}
