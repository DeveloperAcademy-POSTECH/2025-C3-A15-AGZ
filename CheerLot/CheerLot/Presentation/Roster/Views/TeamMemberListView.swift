//
//  TeamMemberListView.swift
//  CheerLot
//
//  Created by 이승진 on 6/2/25.
//

import SwiftUI

struct TeamMemberListView: View {
  //  @EnvironmentObject var router: NavigationRouter
  @EnvironmentObject var container: DIContainer
  @EnvironmentObject private var themeManager: ThemeManager
  @Binding var teamMembers: [Player]

  @State private var showToastMessage = false
  @State private var showCheerSongSheet = false
  @State private var selectedPlayerForSheet: Player?

  let viewModel = TeamRoasterViewModel.shared
  var screenName: String = LoggerEvent.View.mainRoasterV

  var body: some View {
    List {
      ForEach($teamMembers, id: \.id) { $player in
        teamMemberCell(for: $player)
      }
      .listRowSeparator(.hidden)
      .listRowInsets(EdgeInsets())
    }
    .listStyle(.plain)
    .refreshable {
      await viewModel.fetchTeamPlayers(for: themeManager.currentTheme.rawValue.uppercased())
    }
    .sheet(item: $selectedPlayerForSheet) { selectedPlayer in
      CheerSongMenuSheetView(
        player: selectedPlayer,
        selectedTheme: themeManager.currentTheme,
        startingMembers: teamMembers
      )
      .presentationDetents([
        .height(
          CGFloat((selectedPlayer.cheerSongList?.count ?? 0))
            * DynamicLayout.dynamicValuebyHeight(78.6)
            + DynamicLayout.dynamicValuebyHeight(76.7)
        )
      ])
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
    let hasSong = player.wrappedValue.cheerSongList?.isEmpty == false

    TeamMemberCell(
      selectedTheme: themeManager.currentTheme,
      memberName: player.wrappedValue.name,
      hasSong: hasSong,
      backNumber: player.wrappedValue.jerseyNumber
    )
    /// touch 영역 cell 전체로
    .contentShape(Rectangle())
    /// cell tapping시,
    .onTapGesture {
      AnalyticsLogger.logCellClick(
        screen: screenName, cell: LoggerEvent.CellEvent.playerTapped, index: player.id)
      if let cheerSongs = player.wrappedValue.cheerSongList {
        switch cheerSongs.count {
        case 0:
          // 응원가 없음: 토스트
          showToastMessage = true
          DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            showToastMessage = false
          }
        case 1:
          // 1개:  바로 재생
          if let song = cheerSongs.first {
            let index = teamIndexFor(player: player.wrappedValue, song: song)
            container.navigationRouter.push(
              to: .playCheerSong(players: teamMembers, startIndex: index))
          }
        default:
          // 2개 이상: 시트 열기
          selectedPlayerForSheet = player.wrappedValue
          showCheerSongSheet = true
        }
      } else {
        print("❗️ cheerSongs == nil")
      }
    }
    .contextMenu {
      if let cheerSongList = player.wrappedValue.cheerSongList {
        ForEach(Array(cheerSongList.enumerated()), id: \.element.id) { index, song in
          Button {
            AnalyticsLogger.logCellClick(
              screen: screenName,
              cell: LoggerEvent.CellEvent.cheerSongTapped,
              index: song.id
            )
            container.navigationRouter.push(
              to:
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
  /// 특정 선수 응원가 위치를 계산하는 함수
  func teamIndexFor(player: Player, song: CheerSong) -> Int {
    let flattened = teamMembers.flatMap { p in
      (p.cheerSongList ?? []).map { CheerSongItem(player: p, song: $0) }
    }

    // player + song 조합을 전체 곡 리스트에서 찾아서 그 위치 반환
    return flattened.firstIndex {
      $0.player.id == player.id && $0.song.title == song.title
    } ?? 0
  }
}
