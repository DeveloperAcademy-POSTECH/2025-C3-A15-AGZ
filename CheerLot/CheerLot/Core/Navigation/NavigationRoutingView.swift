//
//  NavigationRoutingView.swift
//  CheerLot
//
//  Created by 이승진 on 9/5/25.
//

import SwiftUI

/// 앱 내에서 특정 화면으로의 이동을 처리하는 라우팅 뷰
struct NavigationRoutingView: View {

  /// 의존성 주입을 위한 환경 객체
  @EnvironmentObject var container: DIContainer

  @EnvironmentObject private var themeManager: ThemeManager
  @Bindable private var viewModel = TeamRoasterViewModel.shared

  // MARK: - Body
  var body: some View {
    NavigationStack(path: $container.navigationRouter.destination) {
      StartView()
        .navigationDestination(for: NavigationDestination.self) { dest in
          switch dest {
          case .teamRoaster:
            TeamRoasterView()

          case .changeMemember(let selectedPlayer):
            ChangeStartingMemberView(
              backupMembers: $viewModel.backupPlayers,
              changeForPlayer: selectedPlayer
            )

          case .playCheerSong(let players, let startIndex):
            CheerSongView(players: players, startIndex: startIndex)

          case .appInfo:
            MainAppInfoView()

          case .termsOfService:
            AppInfoTextPageView(title: "이용약관", text: Constants.AppInfo.termsOfService)

          case .privacyPolicy:
            AppInfoTextPageView(title: "개인정보 처리방침", text: Constants.AppInfo.privacyPolicy)

          case .copyright:
            AppInfoTextPageView(title: "저작권 법적고지", text: Constants.AppInfo.copyrightPolicy)

          case .aboutMaker:
            AboutMakerView()
          }
        }
    }
  }

  @ViewBuilder
  private func StartView() -> some View {
    if themeManager.isThemeInitialized {
      TeamRoasterView()
    } else {
      TeamSelectView()
    }
  }
}
