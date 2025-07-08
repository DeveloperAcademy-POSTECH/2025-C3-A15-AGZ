//
//  MainRoute.swift
//  CheerLot
//
//  Created by 이현주 on 6/1/25.
//

import Foundation

enum MainRoute: Hashable {
  case teamRoaster
  case changeMemeber(selectedPlayer: Player)
  case playCheerSong(players: [Player], startIndex: Int)
  case appInfo
  
  // 설정 페이지 관련 라우팅
    case termsOfService
    case privacyPolicy
    case copyright
//    case reportBug
    case aboutMaker
}
