//
//  TeamCard.swift
//  CheerLot
//
//  Created by 이승진 on 6/10/25.
//

import SwiftUI

struct TeamCard: View {
  let theme: Theme
  let isSelected: Bool

  var body: some View {
    VStack(spacing: DynamicLayout.dynamicValuebyHeight(6)) {
      Text(theme.teamFullEngName)
        .lineHeightMultipleAdaptFreshman(fontSize: 24, lineHeight: 0.9)
        .multilineTextAlignment(.center)

      Text(theme.longName)
        .lineHeightMultipleAdaptPretend(
          fontType: .semibold, fontSize: 11, lineHeight: 1.0, letterSpacing: -0.04)
    }
    .padding()
    .frame(maxWidth: .infinity)
    .frame(height: DynamicLayout.dynamicValuebyHeight(112))
    .background(
      RoundedRectangle(cornerRadius: DynamicLayout.dynamicValuebyWidth(10))
        .fill(isSelected ? theme.primaryColor01 : .white)
    )
    .overlay(
      RoundedRectangle(cornerRadius: DynamicLayout.dynamicValuebyWidth(10))
        .stroke(Color.gray02, lineWidth: 1)
    )
    .foregroundColor(isSelected ? .white : .gray04)
  }
}

#Preview {
  TeamCard(theme: .HT, isSelected: true)
}
