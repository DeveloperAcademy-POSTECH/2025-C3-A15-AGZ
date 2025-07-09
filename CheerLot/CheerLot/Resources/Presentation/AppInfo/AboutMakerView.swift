//
//  AboutMakerView.swift
//  CheerLot
//
//  Created by 이현주 on 7/6/25.
//

import SwiftUI

struct AboutMakerView: View {
    var body: some View {
        VStack(spacing: DynamicLayout.dynamicValuebyHeight(15)) {
            CustomNavigationBar(
                showBackButton: true,
                title: { Text("만든 사람들") },
                tintColor: .black
            )
            
            bottomMenuView
                .padding(.horizontal, DynamicLayout.dynamicValuebyWidth(21))
        }
        .ignoresSafeArea(edges: .top)
    }
    
    private var bottomMenuView: some View {
        VStack(spacing: DynamicLayout.dynamicValuebyHeight(16)) {
            
            RoundedRectangle(cornerRadius: 1)
                .strokeBorder(style: StrokeStyle(lineWidth: 1, dash: [17]))
                .foregroundStyle(Color.gray02)
                .frame(height: 1)
            
            List {
                ForEach(AboutMakerInfo.allCases) { menu in
                    AppInfoMenuCell(title: menu.rawValue)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            if let url = URL(string: menu.url) {
                                UIApplication.shared.open(url)
                            }
                        }
                }
                .listRowSeparator(.hidden)
                .listRowInsets(EdgeInsets())
            }
            .listStyle(.plain)
            .scrollDisabled(true)
        }
    }
}

#Preview {
    AboutMakerView()
}
