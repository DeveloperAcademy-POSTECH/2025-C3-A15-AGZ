//
//  TeamRoasterView.swift
//  CheerLot
//
//  Created by 이현주 on 5/29/25.
//

import SwiftData
import SwiftUI

struct TeamRoasterView: View {

  @StateObject private var router = NavigationRouter()
  @Environment(\.modelContext) private var modelContext
  @Bindable private var viewModel = TeamRoasterViewModel()

  // 선택 Theme를 appStorage에 enum rawValue값으로 저장
  @AppStorage("selectedTheme") private var selectedThemeRaw: String = Theme.SS.rawValue

  // 선택한 Theme
  var selectedTheme: Theme {
    get { Theme(rawValue: selectedThemeRaw) ?? .SS }
    set { selectedThemeRaw = newValue.rawValue }
  }

  var body: some View {
    NavigationStack(path: $router.path) {
      VStack(spacing: DynamicLayout.dynamicValuebyHeight(15.5)) {

        teamTopView

        MemberListMenuSegmentControl(
          selectedSegment: $viewModel.selectedSegment, selectedTheme: selectedTheme
        )
        .padding(.horizontal, DynamicLayout.dynamicValuebyWidth(43))

        memberListTabView

      }
      .ignoresSafeArea(edges: .top)
      .onAppear {
        viewModel.setModelContext(modelContext)
        viewModel.setTheme(selectedTheme)
        let teamCode = selectedTheme.rawValue.uppercased()
        Task {
          await viewModel.fetchLineup(for: teamCode)
        }
      }
      .onChange(of: selectedTheme) { _, newTheme in
        viewModel.setTheme(newTheme)
        let teamCode = newTheme.rawValue.uppercased()
        Task {
          await viewModel.fetchLineup(for: teamCode)
        }
      }
      .navigationDestination(for: MainRoute.self) { route in
        switch route {
        case .changeMemeber(let selectedPlayer):
          ChangeStartingMemberView(
            router: router, 
            viewModel: viewModel,
            backupMembers: $viewModel.backupPlayers, 
            changeForPlayer: selectedPlayer
          )
          .toolbar(.hidden)
        case .playCheerSong(let selectedCheerSong):
          // 현재 임시 뷰 (후에 이안 뷰 연결 예정)
          CheerSongView()
            .toolbar(.hidden)
        }
      }
    }
  }

  // 팀 primary 색상을 바탕으로 두는 main 상단 뷰
  private var teamTopView: some View {
    ZStack(alignment: .bottom) {
      RoundedCornerShape(
        radius: DynamicLayout.dynamicValuebyWidth(10), corners: [.bottomLeft, .bottomRight]
      )
      .fill(selectedTheme.primaryColor)
      .frame(maxWidth: .infinity)
      .frame(height: DynamicLayout.dynamicValuebyHeight(210))

      // 그라디언트 배경
      selectedTheme.topViewBackground
        .resizable()
        .frame(height: DynamicLayout.dynamicValuebyHeight(210))
        .frame(maxWidth: .infinity)
        .clipped()
        .offset(y: DynamicLayout.dynamicValuebyHeight(15))

      teamGameInfoView
        .padding(.bottom, DynamicLayout.dynamicValuebyHeight(24))
    }
  }

  // 팀 슬로건과 팀 eng title을 담은 vertical view
  private var teamInfoView: some View {
    VStack(alignment: .leading, spacing: 6) {
      Text(selectedTheme.teamSlogan)
        .lineHeightMultipleAdaptPretend(fontType: .semibold, fontSize: 12, lineHeight: 1.2)
        .foregroundStyle(Color.white.opacity(0.8))

      Text(selectedTheme.teamFullEngName)
        .lineHeightMultipleAdaptFreshman(fontSize: 33, lineHeight: 1.15)
        .foregroundStyle(Color.white)
    }
  }

  // 팀 정보와 경기정보(날짜, 대진)을 담은 horizon view
  private var teamGameInfoView: some View {
    HStack(alignment: .bottom, spacing: DynamicLayout.dynamicValuebyWidth(20)) {

      teamInfoView

      // API 받아왔습니다
      Text(
        viewModel.lastUpdated.isEmpty
          ? "데이터 로딩 중..."
          : "\(viewModel.lastUpdated) | \(viewModel.opponent)"
      )
      .foregroundStyle(Color.white)
      .basicTextStyle(fontType: .semibold, fontSize: 16)
    }
    .frame(maxWidth: .infinity)
  }

  // tab menu에 해당하는 view
  private var memberListTabView: some View {
    Group {
      switch viewModel.selectedSegment {
      case .starting:
        StartingMemberListView(
          router: router,
          startingMembers: $viewModel.players,
          selectedTheme: selectedTheme
        )
      case .team:
        // teamMember -> 전체 팀으로 바꿔야함
        TeamMemberListView(
          router: router,
          teamMembers: $viewModel.allPlayers,
          selectedTheme: selectedTheme
        )
      }
    }
  }
}

#Preview {
  TeamRoasterView()
}
