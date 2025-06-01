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
    
    var body: some View {
        List {
            ForEach($startingMembers, id: \.id) { $player in
                let hasSong = player.cheerSongList != nil
                StartingMemberCell(selectedTheme: selectedTheme, number: player.battingOrder, memberName: player.name, memberPosition: player.position, hasSong: hasSong)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        // 응원가가 없냐 있냐 / 1개인가 여러개인가 분기처리
                        
                        if player.cheerSongList == nil {
                            
                        }
                        router.push(.playCheerSong(selectedPlayer: player))
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
                        
                        // 응원가가 없냐 있냐 / 1개인가 여러개인가 버튼 갯수 처리
                        Button {
                            router.push(.playCheerSong(selectedPlayer: player))
                        } label: {
                            Label("기본 응원가 재생", systemImage: "baseball.fill")
                        }
                    }
            }
            .listRowSeparator(.hidden)
            .listRowInsets(EdgeInsets())
        }
        .listStyle(.plain)
    }
}

//#Preview {
//  StartingMemberListView()
//}
