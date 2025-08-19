//
//  TeamSelectSheetView.swift
//  CheerLot
//
//  Created by 이승진 on 6/11/25.
//

import SwiftUI

struct TeamSelectSheetView: View {
    // MARK: 주석 정리 -루미-
  //  @Binding var selectedTheme: Theme
  @Environment(\.dismiss) private var dismiss
  @EnvironmentObject private var themeManager: ThemeManager
    // MARK: ViewModel을 제거하고, 파라미터를 패싱하던지, 아니면 ViewModel에 로직을 분리 -루미-
  let viewModel = TeamRoasterViewModel.shared
  var screenName: String = LoggerEvent.View.editTeamV

  @State private var tempSelectedTheme: Theme

  init() {
    _tempSelectedTheme = State(initialValue: ThemeManager.shared.currentTheme)
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
            dismiss()
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
