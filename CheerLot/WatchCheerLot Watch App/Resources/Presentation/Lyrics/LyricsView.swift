//
//  LyricsView.swift
//  WatchCheerLot Watch App
//
//  Created by 이현주 on 6/6/25.
//

import SwiftUI

struct LyricsView: View {
  let players: [PlayerWatchDto]
  let initialPlayer: PlayerWatchDto

  @State private var selectedIndex: Int = 0

  var body: some View {
    TabView(selection: $selectedIndex) {
      ForEach(players.indices, id: \.self) { index in
        let player = players[index]

        Group {
          if !player.cheerSongList.isEmpty {
            ScrollView {
              VStack(alignment: .leading, spacing: 24) {
                ForEach(player.cheerSongList, id: \.self) { song in
                  Text(song.lyrics)
                    .lineHeightMultipleAdaptPretend(fontType: .bold, fontSize: 24, lineHeight: 1.5)
                }
              }
              .padding()
            }
          } else {
            Text("아직 개인\n응원가가 없어요")
              .lineHeightMultipleAdaptPretend(fontType: .bold, fontSize: 18, lineHeight: 1.37)
              .multilineTextAlignment(.center)
          }
        }
        .navigationTitle("\(index + 1) \(player.name)")
        .tag(index)
      }
    }
    .tabViewStyle(.verticalPage)
    .onAppear {
      if let index = players.firstIndex(of: initialPlayer) {
        selectedIndex = index
      }
    }
  }
}
