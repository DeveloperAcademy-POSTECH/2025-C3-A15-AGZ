//
//  WatchCheerLotApp.swift
//  WatchCheerLot Watch App
//
//  Created by 이현주 on 6/2/25.
//

import SwiftUI

@main
struct WatchCheerLot_Watch_AppApp: App {

  @StateObject private var themeManager = ThemeManager()

  var body: some Scene {
    WindowGroup {
      StartingMemberListView()
        .environmentObject(themeManager)
    }
  }
}
