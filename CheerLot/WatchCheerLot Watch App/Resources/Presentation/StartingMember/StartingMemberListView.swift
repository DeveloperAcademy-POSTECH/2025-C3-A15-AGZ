//
//  StartingMemberListView.swift
//  WatchCheerLot Watch App
//
//  Created by 이현주 on 6/2/25.
//

import SwiftUI

struct StartingMemberListView: View {
    var body: some View {
        NavigationStack {
            ZStack {
                Image(.ssListBG)
                    .resizable()
                    .ignoresSafeArea()
                
                List {
                    ForEach(0...4, id: \.self) {
                        member in
                        NavigationLink {
                            NextView()
                        } label: {
                            Text("1  류지혁")
                                .font(.dynamicPretend(type: .semibold, size: 17))
                                .padding(.leading, WatchDynamicLayout.dynamicValuebyWidth(10))
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    StartingMemberListView()
}
