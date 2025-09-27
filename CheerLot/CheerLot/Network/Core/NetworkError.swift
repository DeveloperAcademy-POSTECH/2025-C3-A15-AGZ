//
//  NetworkError.swift
//  CheerLot
//
//  Created by 이현주 on 9/23/25.
//

import Foundation
import Moya

enum APIType {
  case lineup
  case players
  case version
}

enum NetworkError: Error {
  case decodingError(Error)
  case moyaError(MoyaError, api: APIType)

  /// 디버깅/로그용
  var localizedDescription: String {
    switch self {
    case .decodingError(let error):
      return "데이터 파싱 실패: \(error.localizedDescription)"
    case .moyaError(let error, _):
      return "네트워크 요청 실패: \(error.localizedDescription)"
    }
  }

  /// 사용자 노출용 메시지
  var userMessage: String {
    switch self {
    case .decodingError:
      return "데이터 형식이 올바르지 않습니다."

    case .moyaError(let moyaError, let api):
      switch moyaError {
      case .underlying(let nsError as NSError, _):
        switch nsError.code {
        case NSURLErrorNotConnectedToInternet:
          return "인터넷 연결을 확인해주세요."
        case NSURLErrorTimedOut:
          return "요청 시간이 초과되었습니다."
        default:
          return "네트워크 연결 상태 확인 후\n다시 시도해 주세요"
        }

      case .statusCode(let response):
        switch response.statusCode {
        case 404:
          switch api {
          case .lineup:
            return "선수 명단 정보를 찾을 수 없습니다."
          case .players:
            return "선수 정보를 불러올 수 없습니다."
          case .version:
            return "버전 정보를 불러올 수 없습니다."
          }
        case 500...599:
          return "서버에 일시적인 문제가 발생했습니다."
        default:
          return "요청을 처리할 수 없습니다. (상태코드: \(response.statusCode))"
        }

      default:
        return "네트워크 요청 중 오류가 발생했습니다."
      }
    }
  }
}
