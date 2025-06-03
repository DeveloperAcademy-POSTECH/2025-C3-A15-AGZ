//
//  ChangeMemberNameCell.swift
//  CheerLot
//
//  Created by 이현주 on 6/3/25.
//

import SwiftUI

struct ChangeMemberNameCell: View {
  let selectedTheme: Theme
  let player: Player
  let action: () -> Void
  let selected: Bool

  var body: some View {
    Button(action: action) {
      ZStack {
        RoundedRectangle(cornerRadius: DynamicLayout.dynamicValuebyHeight(8))
          .fill(selected ? selectedTheme.buttonColor.opacity(0.3) : Color.white)
          .stroke(
            selected ? selectedTheme.primaryColor.opacity(0.7) : selectedTheme.buttonColor,
            lineWidth: selected
              ? DynamicLayout.dynamicValuebyWidth(1.5) : DynamicLayout.dynamicValuebyWidth(1))

        Text(player.name)
          .font(.dynamicPretend(type: .semibold, size: 20))
          .foregroundStyle(selected ? selectedTheme.primaryColor : Color.black)
      }
    }
  }
}
