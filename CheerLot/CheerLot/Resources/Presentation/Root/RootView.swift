//
//  RootView.swift
//  CheerLot
//
//  Created by 이현주 on 6/11/25.
//

import SwiftUI

struct RootView: View {
    @EnvironmentObject var router: NavigationRouter
    @EnvironmentObject private var themeManager: ThemeManager
    @State private var viewModel = TeamRoasterViewModel()
    
    var body: some View {
        NavigationStack(path: $router.path) {
            TeamSelectView()
                .onAppear {
                    if themeManager.isThemeInitialized {
                        DispatchQueue.main.async {
                            router.push(.teamRoaster)
                        }
                    }
                }
                .navigationDestination(for: MainRoute.self) { route in
                    switch route {
                    case .teamRoaster:
                        TeamRoasterView(router: router)
                            .toolbar(.hidden)
                    case .changeMemeber(let selectedPlayer):
                      ChangeStartingMemberView(
                        router: router,
                        viewModel: viewModel,
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
}
