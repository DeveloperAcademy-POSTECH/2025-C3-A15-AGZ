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
                        member in
                        NavigationLink {
                            NextView()
                        } label: {
                            Text("\(member.battingOrder)  \(member.name)")
                                .font(.dynamicPretend(type: .semibold, size: 17))
                                .padding(.leading, WatchDynamicLayout.dynamicValuebyWidth(10))
                        }
                    }
                }
            }
            .navigationTitle("7월19일")
            .navigationBarTitleDisplayMode(.automatic)
        }
    }
}

#Preview {
    StartingMemberListView()
}
