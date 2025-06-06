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
      VStack(spacing: DynamicLayout.dynamicValuebyHeight(18)) {
        navigationTopView

        selectedMemberNameView
          .padding(.horizontal, DynamicLayout.dynamicValuebyWidth(97))

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
      .fill(selectedTheme.primaryColor)
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
    GeometryReader { geometry in
      let totalWidth = geometry.size.width
      let selectWidth = totalWidth / 2

      ZStack(alignment: .leading) {
        RoundedRectangle(cornerRadius: DynamicLayout.dynamicValuebyWidth(10))
          .fill(Color.white)
          .stroke(Color.gray03, lineWidth: DynamicLayout.dynamicValuebyWidth(1))

        RoundedCornerShape(
          radius: DynamicLayout.dynamicValuebyWidth(10),
          corners: [.topLeft, .bottomLeft]
        )
        .fill(Color.white)
        .stroke(Color.gray03, lineWidth: DynamicLayout.dynamicValuebyWidth(1))
        .frame(width: selectWidth)

        HStack(spacing: 0) {
          Text("기존 선수")
            .frame(width: selectWidth)
            .font(.dynamicPretend(type: .semibold, size: 16))
            .foregroundStyle(
              Color.black
            )

          Text(changeForPlayer.name)
            .frame(width: selectWidth)
            .font(.dynamicPretend(type: .semibold, size: 16))
            .foregroundStyle(
              selectedTheme.primaryColor
            )
        }
      }
    }
    .frame(height: DynamicLayout.dynamicValuebyHeight(42))
  }

  let columns: [GridItem] = Array(
    repeating: .init(.flexible(), spacing: DynamicLayout.dynamicValuebyWidth(20)), count: 2)

  // 교체선수 그리드 뷰
  private var teamMemberGridView: some View {
    VStack(alignment: .leading, spacing: DynamicLayout.dynamicValuebyHeight(10)) {
      Text("교체 선수")
        .font(.dynamicPretend(type: .semibold, size: 16))
        .foregroundStyle(Color.gray05)
        .padding(.leading, 37)

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
      .contentMargins(.top, DynamicLayout.dynamicValuebyHeight(2))
      .contentMargins(.bottom, DynamicLayout.dynamicValuebyHeight(12))
    }
  }
}
