//
//  StartingMemberCell.swift
//  CheerLot
//
//  Created by 이현주 on 5/31/25.
//

import SwiftUI

struct StartingMemberCell: View {
    let selectedTheme: Theme
    let number: Int
    let memberName: String
    let memberPosition: String
    let hasSong: Bool
    
    var body: some View {
        HStack(spacing: DynamicLayout.dynamicValuebyWidth(15)) {
            Text("\(number)")
                .font(.dynamicPretend(type: .medium, size: 34))
                .foregroundStyle(selectedTheme.primaryColor)
                .frame(width: DynamicLayout.dynamicValuebyWidth(23))
                .padding(.leading, DynamicLayout.dynamicValuebyWidth(32))
            
            memberInfoView
            
            Spacer()
            
            Image(systemName: "play.fill")
                .resizable()
                .scaledToFit()
                .frame(height: DynamicLayout.dynamicValuebyHeight(22))
                .foregroundStyle(hasSong ? selectedTheme.primaryColor : Color.gray04)
                .padding(.trailing, DynamicLayout.dynamicValuebyWidth(32))
            
        }
        .padding(.vertical, DynamicLayout.dynamicValuebyHeight(7))
    }
    
    // 선수 이름과 포지션을 담은 vertical view
    private var memberInfoView: some View {
        VStack(alignment: .leading, spacing: DynamicLayout.dynamicValuebyWidth(6)) {
            Text(memberName)
                .font(.dynamicPretend(type: .semibold, size: 20))
                .foregroundStyle(Color.black)
            
            Text(memberPosition)
                .font(.dynamicPretend(type: .medium, size: 13))
                .foregroundStyle(Color.gray05)
        }
    }
}

//#Preview {
//    StartingMemberCell(number: 1, memberName: "김지찬", memberPosition: "지명타자, 좌타", hasSong: true)
//}
