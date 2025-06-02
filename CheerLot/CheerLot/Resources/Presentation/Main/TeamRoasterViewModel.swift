//
//  TeamRoasterViewModel.swift
//  CheerLot
//
//  Created by 이현주 on 5/31/25.
//

import Observation
import SwiftUI

@Observable
class TeamRoasterViewModel: ObservableObject {

  var selectedSegment: MemberListMenuSegment = .starting

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
