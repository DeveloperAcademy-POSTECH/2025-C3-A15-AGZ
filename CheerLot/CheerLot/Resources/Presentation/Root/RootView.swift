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
            TeamRoasterView()
              .toolbar(.hidden)
          case .changeMemeber(let selectedPlayer):
            ChangeStartingMemberView(
              backupMembers: $viewModel.backupPlayers,
              changeForPlayer: selectedPlayer
            )
            .toolbar(.hidden)
          case .playCheerSong(let players, let startIndex):
            CheerSongView(players: players, startIndex: startIndex)
              .toolbar(.hidden)
          case .appInfo:
            MainAppInfoView()
              .toolbar(.hidden)

          // 설정 페이지 관련 라우팅
          case .termsOfService:
            AppInfoTextPageView(title: "이용약관", text: Constants.AppInfo.termsOfService)
              .toolbar(.hidden)
          case .privacyPolicy:
            AppInfoTextPageView(title: "개인정보 처리방침", text: Constants.AppInfo.privacyPolicy)
              .toolbar(.hidden)
          case .copyright:
            AppInfoTextPageView(title: "저작권 법적고지", text: Constants.AppInfo.copyrightPolicy)
              .toolbar(.hidden)
          case .aboutMaker:
            AboutMakerView()
              .toolbar(.hidden)
          }
        }
    }
    .environmentObject(router)
  }

  @ViewBuilder
  func StartView() -> some View {
    if themeManager.isThemeInitialized {
      TeamRoasterView()
        .task {
          if !didAutoNavigate {
            didAutoNavigate = true
            // 최초에만 push하고, 현재 루트는 유지
          }
        }
    } else {
      TeamSelectView()
    }
  }

}
