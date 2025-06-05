//
//  StartingMemberListView.swift
//  WatchCheerLot Watch App
//
//  Created by 이현주 on 6/2/25.
//

import SwiftUI

struct StartingMemberListView: View {
    
    @Bindable private var viewModel = StartingMemberListViewModel()
    
    var body: some View {
        NavigationStack {
            ZStack {
                Image(.ssListBG)
                    .resizable()
                    .ignoresSafeArea()
                
                List {
                    ForEach(viewModel.players, id: \.self) {
                        player in
                        NavigationLink {
                            NextView(player: player)
                        } label: {
                            Text("\(player.battingOrder)  \(player.name)")
                                .font(.dynamicPretend(type: .semibold, size: 17))
                                .padding(.leading, WatchDynamicLayout.dynamicValuebyWidth(10))
                        }
                    }
                }
            }
            .navigationTitle(viewModel.lastUpdatedDate)
            .navigationBarTitleDisplayMode(.automatic)
        }
    }
}

#Preview {
    StartingMemberListView()
}
