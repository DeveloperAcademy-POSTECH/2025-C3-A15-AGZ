//
//  GameState.swift
//  CheerLot
//
//  Created by 이승진 on 9/28/25.
//

import Foundation

/// 메인뷰에서 보여줄 게임 상태를 위한 Enum
enum GameState {
  case normal  // 오늘 경기 있음
  case noGame  // 경기 없음 (월요일 + 우천취소)
  case noSeason  // 시즌 종료
}
