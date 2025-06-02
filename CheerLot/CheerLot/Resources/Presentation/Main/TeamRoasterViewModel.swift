//
//  TeamRoasterViewModel.swift
//  CheerLot
//
//  Created by 이현주 on 5/31/25.
//

import Foundation
import Observation
import SwiftUI

@Observable
class TeamRoasterViewModel: ObservableObject {

  var selectedSegment: MemberListMenuSegment = .starting
  private let networkService = LineupNetworkService()
  var players: [Player] = []
  var isLoading = false
  var errorMessage: String?
  var lastUpdated: String = ""
  var opponent: String = ""

  // API 호출 메서드
  func fetchLineup(for teamCode: String) async {
    await MainActor.run {
      isLoading = true
      errorMessage = nil
    }

    do {
      let response = try await networkService.fetchLineup(teamCode: teamCode)

      await MainActor.run {

        if response.updated == lastUpdated {
          self.isLoading = false
          return
        }

        self.lastUpdated = response.updated
        let ourTeam = getTeamName(from: teamCode)
        self.opponent = "\(ourTeam) vs \(response.opponent)"

        self.players = convertPlayers(from: response)

        // 디버깅: 데이터 확인
        print("API 응답 성공!")
        print("업데이트 날짜: \(self.lastUpdated)")
        print("상대팀: \(self.opponent)")
        print("선수 수: \(self.players.count)")

        if let firstPlayer = self.players.first {
          print(
            "첫 번째 선수: \(firstPlayer.name), 포지션: \(firstPlayer.position), 타순: \(firstPlayer.battingOrder)"
          )
        }

        self.isLoading = false
      }
    } catch {
      await MainActor.run {
        print("API 호출 실패: \(error)")
        handleError(error)
        self.isLoading = false
      }
    }
  }

  // DTO 변환 메서드
  private func convertPlayers(from response: LineupResponse) -> [Player] {
    return response.players.compactMap { dto in
      convertToPlayer(from: dto)
    }
    .sorted { $0.battingOrder < $1.battingOrder }  // 타순 순서로 정렬
  }

  // 개별 Player 변환 메서드
  private func convertToPlayer(from dto: PlayerDTO) -> Player {
    let battingOrder = Int(dto.batsOrder) ?? 0
    let id = Int(dto.backNumber) ?? 0

    return Player(
      cheerSongList: nil,  // todo: 로컬에서 응원가 가져오기
      id: id,
      name: dto.name,
      position: dto.position + " / " + dto.batsThrows,
      battingOrder: battingOrder
    )
  }

  // 에러 처리 메서드
  private func handleError(_ error: Error) {
    if let networkError = error as? NetworkError {
      switch networkError {
      case .decodingError:
        errorMessage = "데이터 형식이 올바르지 않습니다."
      case .moyaError(let moyaError):
        switch moyaError {
        case .underlying(let nsError, _):
          if (nsError as NSError).code == NSURLErrorNotConnectedToInternet {
            errorMessage = "인터넷 연결을 확인해주세요."
          } else if (nsError as NSError).code == NSURLErrorTimedOut {
            errorMessage = "요청 시간이 초과되었습니다."
          } else {
            errorMessage = "네트워크 오류가 발생했습니다."
          }
        case .statusCode(let response):
          if response.statusCode == 404 {
            errorMessage = "선수 명단 정보를 찾을 수 없습니다."
          } else if response.statusCode >= 500 {
            errorMessage = "서버에 일시적인 문제가 발생했습니다."
          } else {
            errorMessage = "요청을 처리할 수 없습니다. (상태코드: \(response.statusCode))"
          }
        default:
          errorMessage = "네트워크 요청 중 오류가 발생했습니다."
        }
      }
    } else {
      errorMessage = "알 수 없는 오류가 발생했습니다."
    }
  }

  private func getTeamName(from teamCode: String) -> String {
    switch teamCode.uppercased() {
    case "SS": return "삼성"
    case "HH": return "한화"
    case "LG": return "LG"
    case "LT": return "롯데"
    case "NC": return "NC"
    case "SK": return "SK"
    case "OB": return "두산"
    case "KT": return "KT"
    case "WO": return "키움"
    case "HT": return "KIA"
    default: return teamCode
    }
  }

  var dummyPlayers: [Player] = [
    Player(
      cheerSongList: [
        CheerSong(title: "기본 응원가", lyrics: "", audioFileName: ""),
        CheerSong(title: "안타", lyrics: "", audioFileName: ""),
      ], id: 0, name: "김현수", position: "LF", battingOrder: 1),
    Player(
      cheerSongList: [CheerSong(title: "기본 응원가", lyrics: "", audioFileName: "")], id: 1,
      name: "박해민", position: "CF", battingOrder: 2),
    Player(
      cheerSongList: [CheerSong(title: "기본 응원가", lyrics: "", audioFileName: "")], id: 2,
      name: "오지환", position: "RF", battingOrder: 3),
    Player(id: 3, name: "채은성", position: "RF", battingOrder: 4),
    Player(
      cheerSongList: [
        CheerSong(title: "기본 응원가", lyrics: "", audioFileName: ""),
        CheerSong(title: "안타", lyrics: "", audioFileName: ""),
      ], id: 4, name: "문보경", position: "3B", battingOrder: 5),
    Player(
      cheerSongList: [
        CheerSong(title: "기본 응원가", lyrics: "", audioFileName: ""),
        CheerSong(title: "안타", lyrics: "", audioFileName: ""),
      ], id: 5, name: "김민성", position: "2B", battingOrder: 6),
    Player(
      cheerSongList: [CheerSong(title: "기본 응원가", lyrics: "", audioFileName: "")], id: 6,
      name: "유강남", position: "C", battingOrder: 7),
    Player(
      cheerSongList: [
        CheerSong(title: "기본 응원가", lyrics: "", audioFileName: ""),
        CheerSong(title: "안타", lyrics: "", audioFileName: ""),
      ], id: 7, name: "서건창", position: "1B", battingOrder: 8),
    Player(id: 8, name: "이재원", position: "DH", battingOrder: 9),
  ]
}
