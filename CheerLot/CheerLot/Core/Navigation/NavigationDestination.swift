//
//  NavigationDestination.swift
//  CheerLot
//
//  Created by 이승진 on 9/5/25.
//

import Foundation

enum NavigationDestination: Equatable, Hashable {
  case teamRoaster
  case changeMemember(selectedPlayer: Player)
  case playCheerSong(players: [Player], startIndex: Int)
  case appInfo

  // 설정 페이지 관련 라우팅
  case termsOfService
  case privacyPolicy
  case copyright
  case aboutMaker
}
