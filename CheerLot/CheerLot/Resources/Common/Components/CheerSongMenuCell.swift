//
//  CheerSongMenuCell.swift
//  CheerLot
//
//  Created by 이현주 on 6/1/25.
//

import SwiftUI

struct CheerSongMenuCell: View {
  let cheerSong: CheerSong
  let selectedTheme: Theme

  var body: some View {
    VStack(spacing: DynamicLayout.dynamicValuebyHeight(25.5)) {
      Divider()
        .foregroundStyle(Color.gray02)

      Text(cheerSong.title)
        .font(.dynamicPretend(type: .bold, size: 20))
        .foregroundStyle(selectedTheme.primaryColor01)
        .padding(.bottom, DynamicLayout.dynamicValuebyHeight(25.5))
    }
  }
}

#Preview {
  CheerSongMenuCell(
    cheerSong: CheerSong(title: "기본 응원가", lyrics: "랄라라", audioFileName: "basic.mp3"),
    selectedTheme: .SS)
}
