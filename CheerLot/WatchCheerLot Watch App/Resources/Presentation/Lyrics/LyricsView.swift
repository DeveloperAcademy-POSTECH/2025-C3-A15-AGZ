//
//  LyricsView.swift
//  WatchCheerLot Watch App
//
//  Created by 이현주 on 6/6/25.
//

import SwiftUI

struct LyricsView: View {
  let player: PlayerWatchDto

  var body: some View {
    ScrollView {
      if !player.cheerSongList.isEmpty {
        VStack(alignment: .leading, spacing: 24) {
          ForEach(player.cheerSongList, id: \.self) { song in
            Text(song.lyrics)
              .font(.dynamicPretend(type: .bold, size: 24))
          }
        }
        .navigationTitle(player.name)
        .padding()
      } else {
        Text("아직 개인\n응원가가 없어요")
          .font(.dynamicPretend(type: .bold, size: 18))
          .multilineTextAlignment(.center)
      }
    }
  }
}

//#Preview {
//    LyricsView()
//}
