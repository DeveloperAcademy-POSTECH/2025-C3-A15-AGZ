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
                let hasSong = player.cheerSongList != nil
                StartingMemberCell(selectedTheme: selectedTheme, number: player.battingOrder, memberName: player.name, memberPosition: player.position, hasSong: hasSong)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        // 응원가가 없을때, 1개일 때, 2개 이상일 때
                        if let cheerSongs = player.cheerSongList {
                            if cheerSongs.count == 1 {
                                router.push(.playCheerSong(selectedCheerSong: cheerSongs.first!))
                            } else {
                                selectedPlayerForSheet = player
                                showCheerSongSheet = true
                            }
                        } else {
                            showToastMessage = true
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                showToastMessage = false
                            }
                        }
                    }
                    .swipeActions(edge: .trailing) {
                        Button {
                            router.push(.changeMemeber(selectedPlayer: player))
                        } label: {
                            Label("Change", image: .changeIcon)
                        }
                        .tint(Color.edit)
                    }
                    .contextMenu {
                        Button {
                            router.push(.changeMemeber(selectedPlayer: player))
                        } label: {
                            Label("교체", systemImage: "arrow.trianglehead.2.clockwise.rotate.90")
                        }
                        
                        // 응원가가 갯수만큼 Context Menu Button 생성
                        if let cheerSongList = player.cheerSongList {
                            ForEach(cheerSongList, id: \.id) { song in
                                Button {
                                    router.push(.playCheerSong(selectedCheerSong: song))
                                } label: {
                                    Label(song.title, systemImage: "baseball.fill")
                                }
                            }
                        }
                    }
            }
            .listRowSeparator(.hidden)
            .listRowInsets(EdgeInsets())
        }
        .listStyle(.plain)
        .sheet(isPresented: $showCheerSongSheet) {
            if let selectedPlayer = selectedPlayerForSheet {
                CheerSongMenuSheetView(router: router, player: selectedPlayer, selectedTheme: selectedTheme)
                    .presentationDetents([.medium])
            }
        }

        .overlay(alignment: .bottom) {
            if showToastMessage {
                CustomToastMessageView(message: "아직 개인 응원가가 없어요")
                    .transition(.opacity)
                    .animation(.easeInOut, value: showToastMessage)
            }
        }
    }
}

//#Preview {
//  StartingMemberListView()
//}
