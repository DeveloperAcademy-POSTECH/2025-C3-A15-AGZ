//
//  StartingMemberCell.swift
//  CheerLot
//
//  Created by 이현주 on 5/31/25.
//

import SwiftUI

struct StartingMemberCell: View {
  let selectedTheme: Theme
  let number: Int
  let memberName: String
  let memberPosition: String
  let hasSong: Bool

  var body: some View {
    HStack(spacing: DynamicLayout.dynamicValuebyWidth(12)) {
      Text("\(number)")
        .font(.dynamicPretend(type: .medium, size: 34))
        .foregroundStyle(selectedTheme.primaryColor02)
        .frame(width: DynamicLayout.dynamicValuebyWidth(32))

      memberInfoView

      Spacer()

      Image(systemName: "play.fill")
        .resizable()
        .scaledToFit()
        .frame(height: DynamicLayout.dynamicValuebyHeight(22))
        .foregroundStyle(hasSong ? selectedTheme.primaryColor02 : Color.gray03)
      //        .padding(.trailing, DynamicLayout.dynamicValuebyWidth(3))
    }
    .padding(.horizontal, DynamicLayout.dynamicValuebyWidth(27))
    .frame(height: DynamicLayout.dynamicValuebyHeight(60))  // 42 + 9 + 9
  }

  // 선수 이름과 포지션을 담은 vertical view
  private var memberInfoView: some View {
    VStack(alignment: .leading, spacing: 0) {
      Text(memberName)
        .lineHeightMultipleAdaptPretend(fontType: .semibold, fontSize: 20, lineHeight: 1.15)
        .foregroundStyle(Color.black)

      Text(memberPosition)
        .basicTextStyle(fontType: .medium, fontSize: 13)
        .foregroundStyle(Color.gray05)
    }
  }
}
