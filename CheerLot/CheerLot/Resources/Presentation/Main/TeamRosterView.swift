//
//  TeamRosterView.swift
//  CheerLot
//
//  Created by 이현주 on 5/29/25.
//

import SwiftUI

struct TeamRosterView: View {
    
    // 선택 Theme를 appStorage에 enum rawValue값으로 저장
    @AppStorage("selectedTheme") private var selectedThemeRaw: String = Theme.SS.rawValue
    
    // 선택한 Theme
    var selectedTheme: Theme {
        get { Theme(rawValue: selectedThemeRaw) ?? .SS }
        set { selectedThemeRaw = newValue.rawValue }
    }
    
    var body: some View {
        VStack {
            
            teamTopView
            
            Spacer()
        }
        .ignoresSafeArea(edges: .top)
    }
    
    private var teamTopView: some View {
        ZStack(alignment: .bottom) {
            Rectangle()
                .fill(selectedTheme.primaryColor)
                .frame(maxWidth: .infinity)
                .frame(height: DynamicLayout.dynamicValuebyHeight(210))
                .cornerRadius(DynamicLayout.dynamicValuebyWidth(10), corners: .bottomLeft)
                .cornerRadius(DynamicLayout.dynamicValuebyWidth(10), corners: .bottomRight)
                
            teamGameInfoView
                .padding(.bottom, DynamicLayout.dynamicValuebyHeight(24))
        }
    }
    
    private var teamInfoView: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(selectedTheme.teamSlogan)
                .lineHeightMultipleAdaptPretend(fontType: .semibold, fontSize: 12, lineHeight: 1.2)
                .foregroundStyle(Color.white.opacity(0.8))
            
            Text(selectedTheme.teamFullEngName)
                .lineHeightMultipleAdaptFreshman(fontSize: 33, lineHeight: 1.15)
                .foregroundStyle(Color.white)
        }
        
    }
    
    private var teamGameInfoView: some View {
        HStack(alignment: .bottom, spacing: DynamicLayout.dynamicValuebyWidth(20)) {
            
            teamInfoView
            
            // 임시값 -> API 받아올 예정
            Text("7월 28일 | KT vs 삼성")
                .foregroundStyle(Color.white)
                .basicTextStyle(fontType: .semibold, fontSize: 16)
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    TeamRosterView()
}
