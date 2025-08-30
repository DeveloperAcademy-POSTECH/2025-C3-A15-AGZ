//
//  AppInfoMenuCell.swift
//  CheerLot
//
//  Created by 이현주 on 7/6/25.
//

import SwiftUI

struct AppInfoMenuCell: View {
  let title: String

  var body: some View {
    HStack {
      Text(title)
        .lineHeightMultipleAdaptPretend(
          fontType: .medium, fontSize: 16, lineHeight: 1.3, letterSpacing: -0.02
        )
        .foregroundStyle(Color.black)

      Spacer()

      Image(systemName: "chevron.right")
        .resizable()
        .scaledToFit()
        .fontWeight(.semibold)
        .foregroundStyle(Color.gray03)
        .frame(height: DynamicLayout.dynamicValuebyHeight(14))
        .padding(.trailing, 3)
    }
  }
}
