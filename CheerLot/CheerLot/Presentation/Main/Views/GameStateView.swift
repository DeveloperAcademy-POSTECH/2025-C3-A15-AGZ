//
//  GameStateView.swift
//  CheerLot
//
//  Created by 이승진 on 9/28/25.
//

import SwiftUI

/// 게임 상태에 따른 뷰
struct GameStateView: View {
  @EnvironmentObject private var themeManager: ThemeManager

  let image: Image
  let title: String
  let buttonTitle: String = "최근 경기 라인업 보기"
  let onTapButton: () -> Void

  var body: some View {
    VStack(spacing: 12) {
      image
        .resizable()
        .aspectRatio(contentMode: .fit)
        .frame(height: 84)

      Text(title)
        .font(.dynamicPretend(type: .medium, size: 16))
        .font(.pretend(type: .medium, size: 16))
        .foregroundStyle(.gray04)

      Button(action: onTapButton) {
        Text(buttonTitle)
          .font(.dynamicPretend(type: .semibold, size: 14))
          .foregroundStyle(themeManager.currentTheme.primaryColor01)
      }
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .padding(.bottom, 80)
  }
}

#Preview {
  GameStateView(
    image: Image(.noSeason),
    title: "다음 시즌 준비중이에요",
    onTapButton: { print("라인업 불러오기") }
  )
}
