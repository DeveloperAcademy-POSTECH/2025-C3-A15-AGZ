//
//  TeamSelectSheetView.swift
//  CheerLot
//
//  Created by 이승진 on 6/11/25.
//

import SwiftUI

struct TeamSelectSheetView: View {
  //  @Binding var selectedTheme: Theme
  @Environment(\.dismiss) private var dismiss
  @EnvironmentObject private var themeManager: ThemeManager
  let viewModel = TeamRoasterViewModel.shared
  var screenName: String = LoggerEvent.View.editTeamV
  var onComplete: (() -> Void)?

  @State private var tempSelectedTheme: Theme

  init(onComplete: (() -> Void)? = nil) {
    _tempSelectedTheme = State(initialValue: ThemeManager.shared.currentTheme)
    self.onComplete = onComplete
  }

  let columns = [
    GridItem(.flexible(), spacing: 15),
    GridItem(.flexible(), spacing: 15),
  ]

  var body: some View {
    VStack(spacing: 26) {
      ZStack {
        Text("응원팀 변경")
          .font(.dynamicPretend(type: .semibold, size: 20))
          .foregroundStyle(.black)

        HStack {
          Spacer()
          Button {
            AnalyticsLogger.logButtonClick(
              screen: screenName, button: LoggerEvent.ButtonEvent.completeBtnTapped)
            themeManager.updateTheme(tempSelectedTheme)
            onComplete?()
          } label: {
            Text("완료")
              .font(.dynamicPretend(type: .regular, size: 18))
              .foregroundStyle(.blue)
          }
        }
      }

      LazyVGrid(columns: columns, spacing: 9) {
        ForEach(Theme.allCases) { theme in
          TeamCard(theme: theme, isSelected: tempSelectedTheme == theme)
            .onTapGesture {
              tempSelectedTheme = theme
              AnalyticsLogger.logCellClick(
                screen: screenName,
                cell: LoggerEvent.CellEvent.teamTapped,
                index: theme.id
              )
            }
        }
      }
    }
    .padding(.horizontal, DynamicLayout.dynamicValuebyWidth(31))
    .onAppear {
      AnalyticsLogger.logScreen(screenName)
    }
  }
}
