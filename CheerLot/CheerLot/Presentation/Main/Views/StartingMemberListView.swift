//
//  StartingMemberListView.swift
//  CheerLot
//
//  Created by 이현주 on 5/31/25.
//

import SwiftUI

struct StartingMemberListView: View {

  @EnvironmentObject var container: DIContainer
  @EnvironmentObject private var themeManager: ThemeManager
  @Binding var startingMembers: [Player]

  let viewModel = TeamRoasterViewModel.shared
  var screenName: String = LoggerEvent.View.mainRoasterV

  @State private var showToastMessage = false
  @State private var showCheerSongSheet = false
  @State private var selectedPlayerForSheet: Player?

  var body: some View {
    switch viewModel.gameState {
    case .normal:
      startingListView
    case .noGame, .noSeason:
      gameStateView
    }
  }

  /// 야없날 추가
  private var gameStateView: some View {
    GameStateView(
      image: viewModel.gameState == .noSeason ? Image(.noSeason) : Image(.noGame),
      title: viewModel.gameState == .noSeason ? "다음 시즌을 준비중이에요" : "오늘은 경기가 없는 날이에요",
      onTapButton: {
        Task {
          await viewModel.restoreLastLocalLineup(
            for: themeManager.currentTheme.rawValue.uppercased()
          )
        }
      }
    )
  }

  @ViewBuilder
  private var startingListView: some View {
    let base = List {
      ForEach($startingMembers, id: \.id) { $player in
        startingMemberCell(for: $player)
      }
      .listRowSeparator(.hidden)
      .listRowInsets(EdgeInsets())
    }
    .scrollIndicators(.hidden)
    .listStyle(.plain)
    // 응원가 2개 이상일 때 띄우는 sheetView
    .sheet(isPresented: $showCheerSongSheet) {
      if let selectedPlayer = selectedPlayerForSheet {
        CheerSongMenuSheetView(
          player: selectedPlayer,
          selectedTheme: themeManager.currentTheme,
          startingMembers: startingMembers
        )
        .presentationDetents([
          .height(
            CGFloat((selectedPlayerForSheet?.cheerSongList?.count ?? 0))
              * DynamicLayout.dynamicValuebyHeight(78.6)  // 응원가 갯수에 따른 시트뷰 높이 조정 꼭 해줘야 합니다!!!
              + DynamicLayout.dynamicValuebyHeight(76.7)
          )
        ])
      }
    }
    // 응원가 없을 때 띄우는 토스트 메시지
    .overlay(alignment: .bottom) {
      CustomToastMessageView(message: "아직 개인 응원가가 없어요")
        .opacity(showToastMessage ? 1 : 0)
        .animation(.easeInOut, value: showToastMessage)
        .padding(.bottom, DynamicLayout.dynamicValuebyHeight(15))
    }

    if viewModel.isRefreshDisabled {
      base
    } else {
      base.refreshable {
        await viewModel.fetchLineup(for: themeManager.currentTheme.rawValue.uppercased())
      }
    }
  }

  @ViewBuilder
  private func startingMemberCell(for player: Binding<Player>) -> some View {
    let hasSong = player.wrappedValue.cheerSongList?.isEmpty == false
    StartingMemberCell(
      selectedTheme: themeManager.currentTheme,
      number: player.wrappedValue.battingOrder,
      memberName: player.wrappedValue.name,
      memberPosition: player.wrappedValue.position,
      hasSong: hasSong
    )
    // touch 영역 cell 전체로
    .contentShape(Rectangle())
    // cell tapping시,
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
            let index = startIndexFor(player: player.wrappedValue, song: song)
            container.navigationRouter.push(
              to:
                .playCheerSong(players: startingMembers, startIndex: index))
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
    // cell 스와이프 액션 설정
    .swipeActions(edge: .trailing) {
      Button {
        AnalyticsLogger.logButtonClick(
          screen: screenName,
          button: LoggerEvent.ButtonEvent.changePlayerBtnTapped
        )
        container.navigationRouter.push(to: .changeMemember(selectedPlayer: player.wrappedValue))
      } label: {
        Label("Change", image: .changeIcon)
      }
      .tint(Color.edit)
    }
    // cell long press action시, context menu 설정
    .contextMenu {
      Button {
        AnalyticsLogger.logButtonClick(
          screen: screenName, button: LoggerEvent.ButtonEvent.changePlayerBtnTapped)
        container.navigationRouter.push(to: .changeMemember(selectedPlayer: player.wrappedValue))
      } label: {
        Label("교체", systemImage: "arrow.trianglehead.2.clockwise.rotate.90")
      }

      // 응원가가 갯수만큼 Context Menu Button 생성
      if let cheerSongList = player.wrappedValue.cheerSongList {
        ForEach(Array(cheerSongList.enumerated()), id: \.element.id) { index, song in
          Button {
            AnalyticsLogger.logCellClick(
              screen: screenName, cell: LoggerEvent.CellEvent.cheerSongTapped, index: song.id)
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
  func startIndexFor(player: Player, song: CheerSong) -> Int {
    let flattened = startingMembers.flatMap { p in
      (p.cheerSongList ?? []).map { CheerSongItem(player: p, song: $0) }
    }

    // player + song 조합을 전체 곡 리스트에서 찾아서 그 위치 반환
    return flattened.firstIndex {
      $0.player.id == player.id && $0.song.title == song.title
    } ?? 0
  }
}
