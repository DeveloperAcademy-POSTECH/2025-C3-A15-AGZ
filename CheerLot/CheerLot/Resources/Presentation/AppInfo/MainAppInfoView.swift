//
//  MainAppInfoView.swift
//  CheerLot
//
//  Created by 이현주 on 7/6/25.
//

import SwiftUI

struct MainAppInfoView: View {
    @EnvironmentObject var router: NavigationRouter
    @State private var showTeamSelectSheet = false
    
    var body: some View {
        VStack(spacing: DynamicLayout.dynamicValuebyHeight(15)) {
            CustomNavigationBar(
                showBackButton: true,
                title: { Text("앱 정보") },
                tintColor: .black
            )
            
            VStack(spacing: DynamicLayout.dynamicValuebyHeight(30)) {
                
                Group {
                    MyTeamInfoView
                    
                    CheerLotInfoView
                }
                .padding(.horizontal, DynamicLayout.dynamicValuebyWidth(21))
            }
        }
        .ignoresSafeArea()
        .frame(maxHeight: .infinity, alignment: .top)
        .sheet(isPresented: $showTeamSelectSheet) {
            TeamSelectSheetView()
                .presentationDetents([.height(DynamicLayout.dynamicValuebyHeight(700))])
        }
    }
    
    func makeTitleWithContents<Content: View>(
        title: String,
        @ViewBuilder content: () -> Content
    ) -> some View {
        VStack(alignment: .leading, spacing: DynamicLayout.dynamicValuebyHeight(8)) {
            Text(title)
                .lineHeightMultipleAdaptPretend(fontType: .semibold, fontSize: 20, lineHeight: 1.3, letterSpacing: -0.02)

            content()
        }
//        .padding()
    }
    
    private var MyTeamInfoView: some View {
        makeTitleWithContents(title: "나의 팀") {
            TeamEditButton {
                showTeamSelectSheet = true
            }
        }
    }
    
    private var CheerLotInfoView: some View {
        makeTitleWithContents(title: "쳐랏 정보") {
            List {
                ForEach(AppInfoMenu.allCases) { menu in
                    AppInfoMenuCell(title: menu.rawValue)
                        .onTapGesture {
                            router.push(menu.route)
                        }
                }
                .listRowSeparator(.hidden)
                .listRowInsets(EdgeInsets())
            }
            .listStyle(.plain)
        }
    }
}

#Preview {
    MainAppInfoView()
}
