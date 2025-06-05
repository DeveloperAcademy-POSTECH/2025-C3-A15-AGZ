//
//  NextView.swift
//  WatchCheerLot Watch App
//
//  Created by 이현주 on 6/3/25.
//

import SwiftUI

struct NextView: View {
    let player: PlayerWatchDto
    
    var body: some View {
        if let firstSong = player.cheerSongList.first {
            Text(firstSong.lyrics)
                .navigationTitle(player.name)
        }
    }
}

//#Preview {
//    NextView()
//}
