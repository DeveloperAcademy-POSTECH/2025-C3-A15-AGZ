//
//  ChangeStartingMemberView.swift
//  CheerLot
//
//  Created by 이현주 on 6/1/25.
//

import SwiftUI

struct ChangeStartingMemberView: View {

  @EnvironmentObject var container: DIContainer
  @EnvironmentObject private var themeManager: ThemeManager
  let viewModel = TeamRoasterViewModel.shared
  // 교체 가능한 선수 리스트
  @Binding var backupMembers: [Player]

  // 교체 대상 선수
  let changeForPlayer: Player
  var screenName: String = LoggerEvent.View.changePlayerV

  // 교체 가능한 선수 그리드 중 선택된 cell 속 선수
  @State private var selectedPlayer: Player?
  @State private var showToast: Bool = false  // 토스트 표시 여부 상태 변수

  var body: some View {
    ZStack {  // 토스트를 오버레이하기 위해 ZStack 사용
      VStack(spacing: DynamicLayout.dynamicValuebyHeight(20)) {
        navigationTopView

        selectedMemberNameView

        teamMemberGridView
      }
      .ignoresSafeArea(edges: .top)

      // 토스트 메시지 뷰
      if showToast {
        CustomToastMessageView(message: "교체할 선수를 선택해주세요.")
          .padding(.bottom, DynamicLayout.dynamicValuebyHeight(50))  // 화면 하단에 여백을 두고 표시
          .frame(maxHeight: .infinity, alignment: .bottom)  // 화면 하단 정렬
          .transition(.opacity.animation(.easeInOut(duration: 0.3)))  // 부드러운 등장/사라짐 효과
          .zIndex(1)  // 다른 뷰들 위에 오도록 zIndex 설정
      }
    }
    .navigationBarBackButtonHidden(true)
    .customNavigation(
      title: "선수 교체",
      leadingAction: { container.navigationRouter.pop() },
      showDoneButton: true,
      trailingAction: {
        AnalyticsLogger.logButtonClick(
          screen: screenName, button: LoggerEvent.ButtonEvent.completeBtnTapped)
        // 선수 교체 로직 추가
        if let playerToStart = selectedPlayer {
          Task {
            await viewModel.swapBattingOrder(
              playerToBench: changeForPlayer, playerToStart: playerToStart)
            container.navigationRouter.pop()
          }
        } else {
          // 교체할 선수가 선택되지 않은 경우
          showToast = true  // 토스트 메시지 표시
        }
      },
      whiteStyle: true
    )
    .onAppear {
      AnalyticsLogger.logScreen(screenName)
    }
    .onChange(of: showToast) { _, newValue in  // oldValue를 _로 변경
      if newValue == true {  // 토스트가 표시되면
        Task {
          try? await Task.sleep(for: .seconds(2))  // 2초 동안 기다렸다가
          showToast = false  // 토스트 숨김
        }
      }
    }
  }

  // 네비게이션 상단 뷰
  private var navigationTopView: some View {
    ZStack(alignment: .bottom) {
      RoundedCornerShape(
        radius: DynamicLayout.dynamicValuebyWidth(10), corners: [.bottomLeft, .bottomRight]
      )
      .fill(themeManager.currentTheme.primaryColor01)
      .frame(maxWidth: .infinity)
      .frame(height: DynamicLayout.dynamicValuebyHeight(105))

      // 그라디언트 배경
      themeManager.currentTheme.changeTopViewBackground
        .resizable()
        .frame(height: DynamicLayout.dynamicValuebyHeight(105))
        .frame(maxWidth: .infinity)
        .clipped()
    }
  }

  // 기존선수 캡슐뷰
  private var selectedMemberNameView: some View {
    VStack(spacing: DynamicLayout.dynamicValuebyHeight(4)) {
      Text("교체 선수")
        .foregroundStyle(Color.gray05)
        .lineHeightMultipleAdaptPretend(
          fontType: .semibold, fontSize: 16, lineHeight: 1.3, letterSpacing: -0.04)

      Text(changeForPlayer.name)
        .foregroundStyle(Color.black)
        .lineHeightMultipleAdaptPretend(
          fontType: .bold, fontSize: 24, lineHeight: 1.2, letterSpacing: -0.05
        )
        .padding(.bottom, DynamicLayout.dynamicValuebyHeight(10))

      Text("교체할 선수를 선택해주세요")
        .foregroundStyle(themeManager.currentTheme.primaryColor01)
        .lineHeightMultipleAdaptPretend(
          fontType: .medium, fontSize: 14, lineHeight: 1.3, letterSpacing: -0.04)
    }
  }

  let columns: [GridItem] = Array(
    repeating: .init(.flexible(), spacing: DynamicLayout.dynamicValuebyWidth(20)), count: 2)

  // 교체선수 그리드 뷰
  private var teamMemberGridView: some View {
    ScrollView(.vertical, showsIndicators: false) {
      LazyVGrid(columns: columns, spacing: DynamicLayout.dynamicValuebyHeight(18)) {
        ForEach($backupMembers, id: \.id) { $backupMember in
          ChangeMemberNameCell(
            selectedTheme: themeManager.currentTheme, player: backupMember,
            action: {
              selectedPlayer = backupMember
              AnalyticsLogger.logCellClick(
                screen: screenName, cell: LoggerEvent.CellEvent.changePlayerTapped,
                index: backupMember.id)
            }, selected: selectedPlayer?.id == backupMember.id
          )
          .frame(height: DynamicLayout.dynamicValuebyHeight(60))
        }
      }
    }
    .contentMargins(.horizontal, 37)
    .contentMargins(.top, DynamicLayout.dynamicValuebyHeight(6))
    .contentMargins(.bottom, DynamicLayout.dynamicValuebyHeight(12))
  }
}
