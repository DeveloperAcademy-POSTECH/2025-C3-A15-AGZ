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
    VStack(spacing: 8) {
      Text(theme.teamFullEngName)
        .font(.dynamicFreshman(size: 18))
        .multilineTextAlignment(.center)

      Text(theme.longName)
        .font(.pretend(type: .semibold, size: 11))
    }
    .padding()
    .frame(height: 112)
    .frame(maxWidth: .infinity)
    .background(
      RoundedRectangle(cornerRadius: 10)
        .fill(isSelected ? theme.primaryColor01 : .white)
    )
    .overlay(
      RoundedRectangle(cornerRadius: 10)
        .stroke(Color.gray02, lineWidth: 1)
    )
    .foregroundColor(isSelected ? .white : .gray04)
  }
}

#Preview {
  TeamCard(theme: .HT, isSelected: true)
}
