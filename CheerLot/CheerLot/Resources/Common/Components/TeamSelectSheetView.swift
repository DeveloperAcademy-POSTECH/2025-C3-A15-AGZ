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
  @EnvironmentObject var themeManager: ThemeManager
  let viewModel = TeamRoasterViewModel.shared

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
          .font(.dynamicPretend(type: .bold, size: 20))
          .foregroundStyle(.black)

        HStack {
          Spacer()
          Button {
            //            selectedTheme = tempSelectedTheme
            themeManager.updateTheme(tempSelectedTheme)
            //            ThemeManager.shared.updateTheme(tempSelectedTheme)
            //            viewModel.updateTheme(selectedTheme)
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
            }
        }
      }
    }
    .padding(.horizontal, DynamicLayout.dynamicValuebyWidth(31))
  }
}
