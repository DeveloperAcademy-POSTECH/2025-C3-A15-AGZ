//
//  TeamEditButton.swift
//  CheerLot
//
//  Created by 이현주 on 7/6/25.
//

import SwiftUI

struct TeamEditButton: View {

  @EnvironmentObject private var themeManager: ThemeManager
  var onTap: () -> Void

  var body: some View {
    Button(action: onTap) {
      ZStack {
        // 제일 아래에 깔리는 RoundRect
        RoundedRectangle(cornerRadius: DynamicLayout.dynamicValuebyWidth(10))
          .fill(themeManager.currentTheme.primaryColor01)
          .frame(height: DynamicLayout.dynamicValuebyHeight(160))
          .frame(maxWidth: .infinity)

        // TeamMainBG
        themeManager.currentTheme.mainTopViewBackground
          .resizable()
          .frame(height: DynamicLayout.dynamicValuebyHeight(160))
          .frame(maxWidth: .infinity)
          .clipShape(RoundedRectangle(cornerRadius: DynamicLayout.dynamicValuebyWidth(10)))
          .clipped()

        // myTeamEditButtonBG
        Image(.myTeamEditButtonBG)
          .resizable()
          .frame(height: DynamicLayout.dynamicValuebyHeight(160))
          .frame(maxWidth: .infinity)
          .clipped()

        // Team eng Name & Team slogan
        TeamTextInfoView
      }
      // edit Image (pencil)
      .overlay(
        Image(systemName: "ellipsis")
          .resizable()
          .scaledToFit()
          .foregroundStyle(Color.white.opacity(0.5))
          .frame(width: DynamicLayout.dynamicValuebyWidth(18))
          //                    .padding(.top, DynamicLayout.dynamicValuebyHeight(17))
          .padding(DynamicLayout.dynamicValuebyWidth(17)),
        alignment: .topTrailing
      )
    }
  }

  private var TeamTextInfoView: some View {
    VStack(spacing: DynamicLayout.dynamicValuebyHeight(4)) {
      Text(themeManager.currentTheme.teamSlogan)
        .lineHeightMultipleAdaptPretend(fontType: .semibold, fontSize: 10, lineHeight: 1.3)
        .foregroundStyle(Color.white.opacity(0.8))

      Text(themeManager.currentTheme.teamFullEngName)
        .lineHeightMultipleAdaptFreshman(fontSize: 36, lineHeight: 0.95)
        .foregroundStyle(Color.white)
    }
  }
}

#Preview {
  TeamEditButton {
    print("팀 변경")
  }
}
