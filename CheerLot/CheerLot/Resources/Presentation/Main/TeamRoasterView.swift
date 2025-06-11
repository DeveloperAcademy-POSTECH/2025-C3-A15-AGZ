//
//  TeamRoasterView.swift
//  CheerLot
//
//  Created by 이현주 on 5/29/25.
//

import SwiftData
import SwiftUI

struct TeamRoasterView: View {

  @ObservedObject var router: NavigationRouter
  @Environment(\.modelContext) private var modelContext
  @Bindable private var viewModel = TeamRoasterViewModel.shared
  @State private var showTeamSelectSheet = false

  var body: some View {
    VStack(spacing: DynamicLayout.dynamicValuebyHeight(15.5)) {

      teamTopView

      MemberListMenuSegmentControl(
        selectedSegment: $viewModel.selectedSegment, selectedTheme: viewModel.currentTheme
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
      viewModel.setModelContext(modelContext)
      viewModel.setTheme(viewModel.currentTheme)
      let teamCode = viewModel.currentTheme.rawValue.uppercased()
      Task {
        await viewModel.fetchLineup(for: teamCode)
      }
    }
    .onChange(of: viewModel.currentTheme) { _, newTheme in
      let teamCode = newTheme.rawValue.uppercased()
      Task {
        await viewModel.fetchLineup(for: teamCode)
      }
    }
    .sheet(isPresented: $showTeamSelectSheet) {
      TeamSelectSheetView(selectedTheme: $viewModel.currentTheme)
        .presentationDetents([.height(DynamicLayout.dynamicValuebyHeight(700))])
    }
  }

  // 팀 primary 색상을 바탕으로 두는 main 상단 뷰
  private var teamTopView: some View {
    ZStack(alignment: .bottom) {
      RoundedCornerShape(
        radius: DynamicLayout.dynamicValuebyWidth(10), corners: [.bottomLeft, .bottomRight]
      )
      .fill(viewModel.currentTheme.primaryColor01)
      .frame(maxWidth: .infinity)
      .frame(height: DynamicLayout.dynamicValuebyHeight(210))

      // 그라디언트 배경
      viewModel.currentTheme.mainTopViewBackground
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
      Text(viewModel.currentTheme.teamSlogan)
        .lineHeightMultipleAdaptPretend(fontType: .semibold, fontSize: 12, lineHeight: 1.3)
        .foregroundStyle(Color.white.opacity(0.8))

      Text(viewModel.currentTheme.teamFullEngName)
        .lineHeightMultipleAdaptFreshman(fontSize: 39, lineHeight: 0.95)
        .foregroundStyle(Color.white)
    }
  }

  // 팀 정보와 경기정보(날짜, 대진)을 담은 horizon view
  private var teamGameInfoView: some View {
    HStack(alignment: .bottom) {

      teamInfoView

      Spacer()

      // API 받아왔습니다
      VStack(alignment: .trailing, spacing: 66) {
        TeamChangeButton {
          showTeamSelectSheet = true
        }

        Text(
          viewModel.lastUpdated.isEmpty
            ? "경기 정보 로딩 중..."
            : "\(viewModel.lastUpdated) | \(viewModel.opponent)"
        )
        .foregroundStyle(Color.white)
        .basicTextStyle(fontType: .semibold, fontSize: 16)
      }
    }
    .frame(maxWidth: .infinity)
    .padding(.leading, DynamicLayout.dynamicValuebyWidth(32))
    .padding(.trailing, DynamicLayout.dynamicValuebyWidth(27))
  }

  // tab menu에 해당하는 view
  private var memberListTabView: some View {
    Group {
      switch viewModel.selectedSegment {
      case .starting:
        StartingMemberListView(
          router: router,
          startingMembers: $viewModel.players,
          selectedTheme: viewModel.currentTheme
        )
      case .team:
        TeamMemberListView(
          router: router,
          teamMembers: $viewModel.allPlayers,
          selectedTheme: viewModel.currentTheme
        )
      }
    }
  }
}
