//
//  CustomToastMessageView.swift
//  CheerLot
//
//  Created by 이현주 on 6/1/25.
//

import SwiftUI

struct CustomToastMessageView: View {
  let message: String

  var body: some View {
    HStack(spacing: DynamicLayout.dynamicValuebyWidth(8)) {
      Image(.caution)
        .resizable()
        .scaledToFit()
        .frame(width: DynamicLayout.dynamicValuebyWidth(18))

      Text(message)
        .font(.dynamicPretend(type: .semibold, size: 16))
        .foregroundStyle(Color.white)
    }
    .padding(.horizontal, DynamicLayout.dynamicValuebyWidth(40.5))
    .padding(.vertical, DynamicLayout.dynamicValuebyHeight(14.5))
    .background(
      RoundedRectangle(cornerRadius: DynamicLayout.dynamicValuebyHeight(24))
        .fill(Color.black.opacity(0.7))
    )
  }
}

#Preview {
  CustomToastMessageView(message: "아직 개인 응원가가 없어요")
}
