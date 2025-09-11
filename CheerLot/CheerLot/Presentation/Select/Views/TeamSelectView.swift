//
//  TeamSelectView.swift
//  CheerLot
//
//  Created by 이승진 on 6/10/25.
//

import SwiftUI

struct TeamSelectView: View {
  @State private var selectedTheme: Theme?
  @EnvironmentObject private var themeManager: ThemeManager
  let viewModel = TeamRoasterViewModel.shared
  var screenName: String = LoggerEvent.View.initSelectTeamV

  let columns = [
    GridItem(.flexible(), spacing: 15),
    GridItem(.flexible(), spacing: 15),
  ]

  var body: some View {
    VStack(spacing: DynamicLayout.dynamicValuebyHeight(25)) {
      Text("응원팀을 선택해주세요")
        .basicTextStyle(fontType: .bold, fontSize: 24)
        .foregroundStyle(.black)

      mainView

    }
    .padding(
      EdgeInsets(
        top: DynamicLayout.dynamicValuebyHeight(50), leading: DynamicLayout.dynamicValuebyWidth(31),
        bottom: DynamicLayout.dynamicValuebyHeight(50),
        trailing: DynamicLayout.dynamicValuebyWidth(31))
    )
    .onAppear {
      AnalyticsLogger.logScreen(screenName)
    }
  }

  /// 그리드 + 버튼
  private var mainView: some View {
    VStack(spacing: DynamicLayout.dynamicValuebyHeight(15)) {
      LazyVGrid(columns: columns, spacing: DynamicLayout.dynamicValuebyHeight(9)) {
        ForEach(Theme.allCases) { theme in
          TeamCard(theme: theme, isSelected: selectedTheme == theme)
            .onTapGesture {
              selectedTheme = theme
              AnalyticsLogger.logCellClick(
                screen: screenName,
                cell: LoggerEvent.CellEvent.teamTapped,
                index: theme.id
              )
            }
        }
      }

      Button {
        if let selectedTheme = selectedTheme {
          themeManager.updateTheme(selectedTheme)
        }
        AnalyticsLogger.logButtonClick(
          screen: screenName, button: LoggerEvent.ButtonEvent.completeBtnTapped)
      } label: {
        Text("완료")
          .font(.dynamicPretend(type: .bold, size: 18))
          .foregroundColor(selectedTheme == nil ? .gray05 : .white)
          .frame(maxWidth: .infinity)
          .padding()
          .background(selectedTheme == nil ? .gray01 : .black)
          .cornerRadius(DynamicLayout.dynamicValuebyHeight(35))
      }
      .disabled(selectedTheme == nil)
    }
  }
}

#Preview {
  TeamSelectView()
}
