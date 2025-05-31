//
//  CheerLotApp.swift
//  CheerLot
//
//  Created by 이현주 on 5/29/25.
//

import SwiftUI

@main
struct CheerLotApp: App {
  var body: some Scene {
    WindowGroup {
      TeamRosterView()
    }
    .modelContainer(for: [Team.self, Player.self, CheerSong.self])
  }
}
