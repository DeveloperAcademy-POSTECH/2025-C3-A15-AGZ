//
//  ChangeStartingMemberView.swift
//  CheerLot
//
//  Created by 이현주 on 6/1/25.
//

import SwiftUI

struct ChangeStartingMemberView: View {
  @ObservedObject var router: NavigationRouter
  let viewModel: TeamRoasterViewModel
  // 교체 가능한 선수 리스트
  @Binding var backupMembers: [Player]

  // 선택 Theme를 appStorage에 enum rawValue값으로 저장
  @AppStorage(wrappedValue: Theme.SS.rawValue, "selectedTheme") private var selectedThemeRaw

  // 선택한 Theme
  var selectedTheme: Theme {
    get { Theme(rawValue: selectedThemeRaw) ?? .SS }
    set { selectedThemeRaw = newValue.rawValue }
  }

  // 교체 대상 선수
  let changeForPlayer: Player

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
      .fill(selectedTheme.primaryColor01)
      .frame(maxWidth: .infinity)
      .frame(height: DynamicLayout.dynamicValuebyHeight(115))

      // 그라디언트 배경
      selectedTheme.changeTopViewBackground
        .resizable()
        .frame(height: DynamicLayout.dynamicValuebyHeight(115))
        .frame(maxWidth: .infinity)
        .clipped()
      //.offset(y: DynamicLayout.dynamicValuebyHeight(7.5))

      CustomNavigationBar(
        showBackButton: true,
        title: { Text("선수 교체") },

        trailing: {
          Button {
            // 선수 교체 로직 추가
            if let playerToStart = selectedPlayer {
              Task {
                await viewModel.swapBattingOrder(
                  playerToBench: changeForPlayer, playerToStart: playerToStart)
                router.pop()
              }
            } else {
              // 교체할 선수가 선택되지 않은 경우
              showToast = true  // 토스트 메시지 표시
            }
          } label: {
            Text("완료")
          }

        }
      )
      .padding(.bottom, DynamicLayout.dynamicValuebyHeight(7.5))
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
        .foregroundStyle(selectedTheme.primaryColor01)
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
            selectedTheme: selectedTheme, player: backupMember,
            action: {
              selectedPlayer = backupMember
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
