//
//  TeamChangeButton.swift
//  CheerLot
//
//  Created by 이승진 on 6/10/25.
//

import SwiftUI

struct TeamChangeButton: View {
  var onTap: () -> Void

  var body: some View {
    Button(action: onTap) {
      HStack(spacing: 4) {
        Image(.hatIcon)
          .resizable()
          .scaledToFit()
          .frame(width: 14, height: 14)
        Text("팀 변경")
          .font(.dynamicPretend(type: .semibold, size: 14))
          .foregroundStyle(.white).opacity(0.7)
      }
      .padding(EdgeInsets(top: 8, leading: 13, bottom: 8, trailing: 13))
      .background(
        RoundedRectangle(cornerRadius: 18)
          .stroke(.white.opacity(0.7), lineWidth: 1)
      )
    }
  }
}

#Preview {
  ZStack {
    Color.blue
    TeamChangeButton {
      print("팀 변경")
    }
  }
}
