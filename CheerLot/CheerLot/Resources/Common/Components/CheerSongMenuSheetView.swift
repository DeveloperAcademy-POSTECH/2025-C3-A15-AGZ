//
//  CheerSongMenuSheetView.swift
//  CheerLot
//
//  Created by 이현주 on 6/1/25.
//

import SwiftUI

struct CheerSongMenuSheetView: View {
    
    @ObservedObject var router: NavigationRouter
    @Environment(\.dismiss) private var dismiss
    let player: Player
    let selectedTheme: Theme
    
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
            ForEach(player.cheerSongList!, id: \.id) { cheerSong in
                CheerSongMenuCell(cheerSong: cheerSong, selectedTheme: selectedTheme)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        dismiss()
                        router.push(.playCheerSong(selectedCheerSong: cheerSong))
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
    CheerSongMenuSheetView(router: NavigationRouter(), player: Player(cheerSongList: [CheerSong(title: "기본 응원가", lyrics: "", audioFileName: ".mp3"), CheerSong(title: "안타", lyrics: "", audioFileName: ".mp3")], id: 0, name: "구자욱", position: "좌타수", battingOrder: 1), selectedTheme: .SS)
}
