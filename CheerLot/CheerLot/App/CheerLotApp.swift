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

  @StateObject private var themeManager = ThemeManager()
  @StateObject private var router = NavigationRouter()

  init() {
    do {
      container = try ModelContainer(for: Team.self, Player.self, CheerSong.self)
      DataMigrationService.migrateDataIfNeeded(modelContext: container.mainContext)

      let currentTheme = ThemeManager.shared.currentTheme
      UIApplication.shared.setAlternateIconName(AppIcon.from(theme: currentTheme).iconName) {
        error in
        if let error = error {
          print("앱 아이콘 설정 실패: \(error.localizedDescription)")
        }
      }

    } catch {
      fatalError("Failed to create ModelContainer: \(error)")
    }
  }

  var body: some Scene {
    WindowGroup {
      RootView()
        .environmentObject(themeManager)
        .environmentObject(router)
    }
    .modelContainer(container)
  }
}
