//
//  StartingMemberListView.swift
//  WatchCheerLot Watch App
//
//  Created by 이현주 on 6/2/25.
//

import SwiftUI

struct StartingMemberListView: View {

  @Bindable private var viewModel = StartingMemberListViewModel()
  @State private var isStartViewVisible = true

  var body: some View {
    NavigationStack {
      ZStack {
        ZStack {
          viewModel.currentTheme.watchListBackground
            .resizable()
            .ignoresSafeArea()

          if viewModel.players.isEmpty {
            EmptyListView
          } else {
            List {
              ForEach(viewModel.players, id: \.self) {
                player in
                NavigationLink {
                  LyricsView(players: viewModel.players, initialPlayer: player)
                } label: {
                  Text("\(player.battingOrder)  \(player.name)")
                    .font(.dynamicPretend(type: .semibold, size: 17))
                    .padding(.leading, WatchDynamicLayout.dynamicValuebyWidth(10))
                }
              }
            }
            .navigationTitle(viewModel.lastUpdatedDate)
            .navigationBarTitleDisplayMode(.automatic)
          }
        }

        if isStartViewVisible {
          StartView()
            .onTapGesture {
              withAnimation(.easeOut(duration: 0.8)) {
                isStartViewVisible = false
              }
            }
            .transition(.opacity)
            .zIndex(1)
        }
      }
    }
  }

  private var EmptyListView: some View {
    VStack(spacing: WatchDynamicLayout.dynamicValuebyHeight(5)) {
      Text("최신 선수 명단이 없어요")
        .font(.dynamicPretend(type: .bold, size: 15))
        .foregroundStyle(Color.white)

      Text("iPhone 앱을 새로고침해 주세요")
        .font(.dynamicPretend(type: .medium, size: 12))
        .foregroundStyle(Color.gray04)
    }
  }
}

#Preview {
  StartingMemberListView()
}
