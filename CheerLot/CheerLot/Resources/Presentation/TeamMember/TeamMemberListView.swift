//
//  TeamMemberListView.swift
//  CheerLot
//
//  Created by 이승진 on 6/2/25.
//

import SwiftUI

struct TeamMemberListView: View {
  @ObservedObject var router: NavigationRouter
  @Binding var teamMembers: [Player]
  let selectedTheme: Theme

  @State private var showToastMessage = false
  @State private var showCheerSongSheet = false
  @State private var selectedPlayerForSheet: Player?

  var body: some View {
    List {
      ForEach($teamMembers, id: \.id) { $player in
        teamMemberCell(for: $player)
      }
      .listRowSeparator(.hidden)
      .listRowInsets(EdgeInsets())
    }
    .listStyle(.plain)
    .sheet(isPresented: $showCheerSongSheet) {
      if let selectedPlayer = selectedPlayerForSheet {
        CheerSongMenuSheetView(
          router: router, player: selectedPlayer, selectedTheme: selectedTheme, startingMembers: []
        )
        .presentationDetents([
          .height(
            CGFloat((selectedPlayer.cheerSongList?.count ?? 0))
              * DynamicLayout.dynamicValuebyHeight(78.6)
              + DynamicLayout.dynamicValuebyHeight(76.7)
          )
        ])
      }
    }
    .overlay(alignment: .bottom) {
      CustomToastMessageView(message: "아직 개인 응원가가 없어요")
        .opacity(showToastMessage ? 1 : 0)
        .animation(.easeInOut, value: showToastMessage)
        .padding(.bottom, DynamicLayout.dynamicValuebyHeight(15))
    }
  }

  @ViewBuilder
  private func teamMemberCell(for player: Binding<Player>) -> some View {
    let hasSong = player.wrappedValue.cheerSongList != nil

    TeamMemberCell(
      selectedTheme: selectedTheme,
      memberName: player.wrappedValue.name,
      hasSong: hasSong
    )
    /// touch 영역 cell 전체로
    .contentShape(Rectangle())
    /// cell tapping시,
    .onTapGesture {
      // 응원가가 없을때, 1개일 때, 2개 이상일 때
      if let cheerSongs = player.wrappedValue.cheerSongList {
        switch cheerSongs.count {
        case 0:
          showToastMessage = true
          DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            showToastMessage = false
          }
        case 1:
          if cheerSongs.first != nil {
            router.push(.playCheerSong(players: [player.wrappedValue], startIndex: 0))
          }
        default:
          selectedPlayerForSheet = player.wrappedValue
          showCheerSongSheet = true
        }
      }
    }
    .contextMenu {
      if let cheerSongList = player.wrappedValue.cheerSongList {
        ForEach(Array(cheerSongList.enumerated()), id: \.element.id) { index, song in
          Button {
            router.push(
              .playCheerSong(
                players: [player.wrappedValue],
                startIndex: index
              ))
          } label: {
            Label(song.title, systemImage: "play.fill")
          }
        }
      }
    }
  }
}
