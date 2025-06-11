//
//  CheerLotApp.swift
//  CheerLot
//
//  Created by 이현주 on 5/29/25.
//

import SwiftData
import SwiftUI

@main
struct CheerLotApp: App {

  let container: ModelContainer

  init() {
    do {
      container = try ModelContainer(for: Team.self, Player.self, CheerSong.self)
      DataMigrationService.migrateDataIfNeeded(modelContext: container.mainContext)
    } catch {
      fatalError("Failed to create ModelContainer: \(error)")
    }
  }

  var body: some Scene {
    WindowGroup {
        TeamSelectView()
    }
    .modelContainer(container)
  }
}
