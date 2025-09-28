//
//  TeamRoasterView.swift
//  CheerLot
//
//  Created by 이현주 on 5/29/25.
//

import SwiftData
import SwiftUI

/// 아마 이게 MainView?
struct TeamRoasterView: View {
  @EnvironmentObject var container: DIContainer
  @EnvironmentObject private var themeManager: ThemeManager
  @Environment(\.modelContext) private var modelContext
  @Bindable private var viewModel = TeamRoasterViewModel.shared
  @State private var showNetworkAlert = false
  var screenName: String = LoggerEvent.View.mainRoasterV

  var body: some View {
    VStack(spacing: DynamicLayout.dynamicValuebyHeight(10.5)) {

      teamTopView
        .padding(.bottom, 5)

      MemberListMenuSegmentControl(
        selectedSegment: $viewModel.selectedSegment, selectedTheme: themeManager.currentTheme
      )
      .padding(.horizontal, DynamicLayout.dynamicValuebyWidth(43))

      if !viewModel.players.isEmpty {
        memberListTabView
      } else {
        VStack {
          Spacer()

          ProgressView()
            .scaleEffect(1.5)

          Spacer()
        }
      }
    }
    .ignoresSafeArea(edges: .top)
    .onAppear {
      AnalyticsLogger.logScreen(screenName)
      viewModel.setModelContext(modelContext)
      let teamCode = themeManager.currentTheme.rawValue.uppercased()

      Task {
        await viewModel.fetchTeamPlayers(for: teamCode)
        await viewModel.fetchLineup(for: teamCode)
      }
    }
    .onChange(of: themeManager.currentTheme) { _, newTheme in
      let teamCode = newTheme.rawValue.uppercased()
      Task {
        await viewModel.fetchTeamPlayers(for: teamCode)
        await viewModel.fetchLineup(for: teamCode)
      }
    }
    .onChange(of: viewModel.errorMessage) { _, newValue in
      showNetworkAlert = newValue != nil
    }
    .alert("네트워크 연결 오류", isPresented: $showNetworkAlert) {
      Button("확인", role: .cancel) {
        AnalyticsLogger.logButtonClick(
          screen: screenName, button: LoggerEvent.ButtonEvent.alertAcceptBtnTapped)
        viewModel.errorMessage = nil
      }
    } message: {
      Text("네트워크 연결 상태 확인 후\n다시 시도해 주세요")
    }
  }

  // 팀 primary 색상을 바탕으로 두는 main 상단 뷰
  private var teamTopView: some View {
    ZStack(alignment: .bottom) {
      RoundedCornerShape(
        radius: DynamicLayout.dynamicValuebyWidth(10), corners: [.bottomLeft, .bottomRight]
      )
      .fill(themeManager.currentTheme.primaryColor01)
      .frame(maxWidth: .infinity)
      .frame(height: DynamicLayout.dynamicValuebyHeight(210))

      // 그라디언트 배경
      themeManager.currentTheme.mainTopViewBackground
        .resizable()
        .frame(height: DynamicLayout.dynamicValuebyHeight(210))
        .frame(maxWidth: .infinity)
        .clipped()

      teamGameInfoView
        .padding(.bottom, DynamicLayout.dynamicValuebyHeight(24))
    }
  }

  // 팀 슬로건과 팀 eng title을 담은 vertical view
  private var teamInfoView: some View {
    VStack(alignment: .leading, spacing: DynamicLayout.dynamicValuebyHeight(4)) {
      Text(themeManager.currentTheme.teamSlogan)
        .lineHeightMultipleAdaptPretend(fontType: .semibold, fontSize: 12, lineHeight: 1.3)
        .foregroundStyle(Color.white.opacity(0.8))

      Text(themeManager.currentTheme.teamFullEngName)
        .lineHeightMultipleAdaptFreshman(fontSize: 40, lineHeight: 0.95)
        .foregroundStyle(Color.white)
    }
  }

  // 팀 정보와 경기정보(날짜, 대진)을 담은 horizon view
  private var teamGameInfoView: some View {
    HStack(alignment: .bottom) {

      teamInfoView

      Spacer()

      // API 받아왔습니다
      VStack(alignment: .trailing, spacing: DynamicLayout.dynamicValuebyHeight(85)) {
        // AppInfo로 가는 button
        Button(action: {
          AnalyticsLogger.logButtonClick(
            screen: screenName, button: LoggerEvent.ButtonEvent.appInfoBtnTapped)
          container.navigationRouter.push(to: .appInfo)
        }) {
          Image(.info)
            .resizable()
            .scaledToFit()
            .frame(width: DynamicLayout.dynamicValuebyWidth(20))
            .foregroundStyle(Color.white.opacity(0.7))
        }

        Text(
          {
            if viewModel.lastUpdated.isEmpty {
              return "경기 정보 로딩 중..."
            }
            switch viewModel.gameState {
            case .noGame, .noSeason:
              let today = Date().formatted(.dateTime.month().day())  // 오늘 날짜
              return "\(today) | 경기없음"
            case .normal:
              return "\(viewModel.lastUpdated) | \(viewModel.opponent)"
            }
          }()
        )
        .foregroundStyle(Color.white)
        .basicTextStyle(fontType: .semibold, fontSize: 14)
      }
    }
    .frame(maxWidth: .infinity)
    .padding(.horizontal, DynamicLayout.dynamicValuebyWidth(27))
  }

  // tab menu에 해당하는 view
  private var memberListTabView: some View {
    Group {
      switch viewModel.selectedSegment {
      case .starting:
        StartingMemberListView(
          startingMembers: $viewModel.players
        )
      case .team:
        TeamMemberListView(
          teamMembers: $viewModel.allPlayers
        )
      }
    }
  }
}
