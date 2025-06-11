//
//  RootView.swift
//  CheerLot
//
//  Created by 이현주 on 6/11/25.
//

import SwiftUI

struct RootView: View {
  @StateObject private var router = NavigationRouter()
  @EnvironmentObject private var themeManager: ThemeManager
  @Bindable private var viewModel = TeamRoasterViewModel.shared
  @State private var didAutoNavigate = false

  var body: some View {
    NavigationStack(path: $router.path) {
      StartView()
        .navigationDestination(for: MainRoute.self) { route in
          switch route {
          case .teamRoaster:
            TeamRoasterView(router: router)
              .toolbar(.hidden)
          case .changeMemeber(let selectedPlayer):
            ChangeStartingMemberView(
              router: router,
              backupMembers: $viewModel.backupPlayers,
              changeForPlayer: selectedPlayer
            )
            .toolbar(.hidden)
          case .playCheerSong(let players, let startIndex):
            CheerSongView(players: players, startIndex: startIndex)
              .toolbar(.hidden)
          }
        }
    }
    .environmentObject(router)
  }

  @ViewBuilder
  func StartView() -> some View {
    if themeManager.isThemeInitialized {
      Color.clear.task {
        if !didAutoNavigate {
          router.push(.teamRoaster)
          didAutoNavigate = true
        }
      }
    } else {
      TeamSelectView()
    }
  }
}
