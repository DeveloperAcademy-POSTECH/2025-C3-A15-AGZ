//
//  StartingMemberListView.swift
//  CheerLot
//
//  Created by 이현주 on 5/31/25.
//

import SwiftUI

struct StartingMemberListView: View {
    @ObservedObject var router: NavigationRouter
    @Binding var startingMembers: [Player]
    let selectedTheme: Theme
    
    @State private var showToastMessage = false
    @State private var showCheerSongSheet = false
    @State private var selectedPlayerForSheet: Player?
    
    var body: some View {
        List {
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
                CheerSongMenuSheetView(router: router, player: selectedPlayer, selectedTheme: selectedTheme, startingMembers: startingMembers)
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
    }
    
    @ViewBuilder
    private func startingMemberCell(for player: Binding<Player>) -> some View {
        let hasSong = player.wrappedValue.cheerSongList?.isEmpty == false
        StartingMemberCell(
            selectedTheme: selectedTheme,
            number: player.wrappedValue.battingOrder,
            memberName: player.wrappedValue.name,
            memberPosition: player.wrappedValue.position,
            hasSong: hasSong
        )
        // touch 영역 cell 전체로
        .contentShape(Rectangle())
        // cell tapping시,
        .onTapGesture {
            // 응원가가 없을때, 1개일 때, 2개 이상일 때
//            if let cheerSongs = player.wrappedValue.cheerSongList {
//                switch cheerSongs.count {
//                case 0:
//                    showToastMessage = true
//                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
//                        showToastMessage = false
//                    }
//                case 1:
//                    if let song = cheerSongs.first {
//                        router.push(.playCheerSong(players: [player.wrappedValue], startIndex: 0))
//                    }
//                default:
//                    selectedPlayerForSheet = player.wrappedValue
//                    showCheerSongSheet = true
//                }
//            }
            guard let cheerSongs = player.wrappedValue.cheerSongList, !cheerSongs.isEmpty else {
                    showToastMessage = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        showToastMessage = false
                    }
                    return
                }

                let allPlayers = startingMembers // 전체 리스트 기준으로 구성
                let flattenedPlaylist: [CheerSongItem] = allPlayers.flatMap { player in
                    (player.cheerSongList ?? []).map { CheerSongItem(player: player, song: $0) }
                }

                guard let targetSong = cheerSongs.first else { return }
                guard let startIndex = flattenedPlaylist.firstIndex(where: {
                    $0.player.id == player.wrappedValue.id &&
                    $0.song.title == targetSong.title
                }) else { return }

                router.push(.playCheerSong(players: allPlayers, startIndex: startIndex))
        }
        // cell 스와이프 액션 설정
        .swipeActions(edge: .trailing) {
            Button {
                router.push(.changeMemeber(selectedPlayer: player.wrappedValue))
            } label: {
                Label("Change", image: .changeIcon)
            }
            .tint(Color.edit)
        }
        // cell long press action시, context menu 설정
        .contextMenu {
            Button {
                router.push(.changeMemeber(selectedPlayer: player.wrappedValue))
            } label: {
                Label("교체", systemImage: "arrow.trianglehead.2.clockwise.rotate.90")
            }
            
            // 응원가가 갯수만큼 Context Menu Button 생성
            if let cheerSongList = player.wrappedValue.cheerSongList {
                ForEach(Array(cheerSongList.enumerated()), id: \.element.id) { index, song in
                    Button {
                        router.push(.playCheerSong(
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
