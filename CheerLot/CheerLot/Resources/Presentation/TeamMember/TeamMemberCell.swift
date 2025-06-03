//
//  TeamMemberCell.swift
//  CheerLot
//
//  Created by 이승진 on 6/2/25.
//

import SwiftUI

struct TeamMemberCell: View {
  let selectedTheme: Theme
  let memberName: String
  let hasSong: Bool

  var body: some View {
    HStack(spacing: DynamicLayout.dynamicValuebyWidth(15)) {
      Text(memberName)
        .font(.dynamicPretend(type: .semibold, size: 20))
        .foregroundStyle(Color.black)
        .padding(.leading, DynamicLayout.dynamicValuebyWidth(32))

      Spacer()

      Image(systemName: "play.fill")
        .resizable()
        .scaledToFit()
        .frame(height: DynamicLayout.dynamicValuebyHeight(22))
        .foregroundStyle(hasSong ? selectedTheme.primaryColor : Color.gray03)
        .padding(.trailing, DynamicLayout.dynamicValuebyWidth(32))
    }
    .padding(.vertical, DynamicLayout.dynamicValuebyHeight(22))
  }
}

//#Preview {
//    TeamMemberCell()
//}
