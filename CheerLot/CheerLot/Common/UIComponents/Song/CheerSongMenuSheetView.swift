//
//  CheerSongMenuSheetView.swift
//  CheerLot
//
//  Created by 이현주 on 6/1/25.
//

import SwiftUI

struct CheerSongMenuSheetView: View {

  @EnvironmentObject var container: DIContainer
  @Environment(\.dismiss) private var dismiss

  let player: Player
  let selectedTheme: Theme
  let startingMembers: [Player]
  var screenName: String = LoggerEvent.View.mainRoasterV

  var body: some View {
    VStack(spacing: 0) {
      playerNameTopView

      CheerSongListView
    }
  }

  private var playerNameTopView: some View {
    HStack {
      Rectangle()
        .fill(Color.clear)
        .frame(width: DynamicLayout.dynamicValuebyWidth(14), height: 14)

      Spacer()

      Text(player.name)
        .font(.dynamicPretend(type: .semibold, size: 20))
        .foregroundStyle(Color.black)

      Spacer()

      Button {
        dismiss()
      } label: {
        Image(systemName: "xmark")
          .resizable()
          .scaledToFit()
          .frame(width: DynamicLayout.dynamicValuebyWidth(14))
          .fontWeight(.semibold)
          .foregroundStyle(Color.gray05)
      }
    }
    .padding(.horizontal, DynamicLayout.dynamicValuebyWidth(37))
    .padding(.vertical, DynamicLayout.dynamicValuebyHeight(24))
  }

  private var CheerSongListView: some View {
    List {
      // 응원가가 2개 이상일 경우에만 나오는 sheetView이므로 강제 언래핑
      ForEach(Array(player.cheerSongList!.enumerated()), id: \.element.id) { index, cheerSong in
        CheerSongMenuCell(cheerSong: cheerSong, selectedTheme: selectedTheme)
          .contentShape(Rectangle())
          .onTapGesture {
            AnalyticsLogger.logCellClick(
              screen: screenName, cell: LoggerEvent.CellEvent.cheerSongTapped, index: cheerSong.id)
            dismiss()
            // 전체 응원가 리스트
            let flattenedPlaylist: [CheerSongItem] = startingMembers.flatMap { player in
              (player.cheerSongList ?? []).map { CheerSongItem(player: player, song: $0) }
            }
            let selectedSong = cheerSong  // 시트에서 선택한 이 곡
            let selectedPlayer = player

            // 현재 탭한 곡이 전체 플레이리스트에서 몇 번째인지 찾기
            guard
              let startIndex = flattenedPlaylist.firstIndex(where: {
                $0.player.id == player.id && $0.song.title == cheerSong.title
              })
            else {
              print("❌ 전체 playlist에서 곡 못 찾음")
              return
            }

            container.navigationRouter.push(
              to:
                .playCheerSong(players: startingMembers, startIndex: startIndex)
            )
          }
      }

      .listRowSeparator(.hidden)
      .listRowInsets(EdgeInsets())
    }
    .listStyle(.plain)
    .scrollDisabled(true)
  }
}

#Preview {
  CheerSongMenuSheetView(
    player: Player(
      cheerSongList: [
        CheerSong(title: "기본 응원가", lyrics: "", audioFileName: ".mp3"),
        CheerSong(title: "안타", lyrics: "", audioFileName: ".mp3"),
      ],
      jerseyNumber: 0, name: "구자욱", position: "좌타수", battingOrder: 1),
    selectedTheme: .SS, startingMembers: []
  )
  .environmentObject(ThemeManager())
  .environmentObject(DIContainer())  // ⬅️ Router 포함
  .modelContainer(for: [Team.self, Player.self, CheerSong.self], inMemory: true)
}
