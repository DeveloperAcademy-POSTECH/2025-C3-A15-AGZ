//
//  TeamSelectView.swift
//  CheerLot
//
//  Created by 이승진 on 6/10/25.
//

import SwiftUI

struct TeamSelectView: View {
  @State private var selectedTheme: Theme? = nil

  let columns = [
    GridItem(.flexible(), spacing: 15),
    GridItem(.flexible(), spacing: 15),
  ]

  var body: some View {
    VStack(spacing: 25) {
      Text("응원팀을 선택해주세요")
        .font(.dynamicPretend(type: .bold, size: 24))
        .foregroundStyle(.black)

      mainView

    }
    .padding(EdgeInsets(top: 50, leading: 31, bottom: 50, trailing: 31))
  }

  /// 그리드 + 버튼
  private var mainView: some View {
    VStack(spacing: 15) {
      LazyVGrid(columns: columns, spacing: 9) {
        ForEach(Theme.allCases) { theme in
          TeamCard(theme: theme, isSelected: selectedTheme == theme)
            .onTapGesture {
              selectedTheme = theme
            }
        }
      }

      Button {
        print("완료 버튼입니다")
      } label: {
        Text("완료")
          .font(.dynamicPretend(type: .bold, size: 18))
          .foregroundColor(selectedTheme == nil ? .gray05 : .white)
          .frame(maxWidth: .infinity)
          .padding()
          .background(selectedTheme == nil ? .gray01 : .black)
          .cornerRadius(36)
      }
      .disabled(selectedTheme == nil)
    }
  }
}

#Preview {
  TeamSelectView()
}
