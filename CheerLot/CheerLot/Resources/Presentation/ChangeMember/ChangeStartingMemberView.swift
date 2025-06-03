//
//  ChangeStartingMemberView.swift
//  CheerLot
//
//  Created by 이현주 on 6/1/25.
//

import SwiftUI

struct ChangeStartingMemberView: View {
    @ObservedObject var router: NavigationRouter
    // 교체 가능한 선수 리스트
    @Binding var backupMembers: [Player]
    
    // 선택 Theme를 appStorage에 enum rawValue값으로 저장
    @AppStorage(wrappedValue: Theme.SS.rawValue, "selectedTheme") private var selectedThemeRaw

    // 선택한 Theme
    var selectedTheme: Theme {
      get { Theme(rawValue: selectedThemeRaw) ?? .SS }
      set { selectedThemeRaw = newValue.rawValue }
    }
    
    // 교체 대상 선수
    let changeForPlayer: Player
    
    // 교체 가능한 선수 그리드 중 선택된 cell 속 선수
    @State private var selectedPlayer: Player?
    
    var body: some View {
        VStack(spacing: DynamicLayout.dynamicValuebyHeight(18)) {
            navigationTopView
            
            selectedMemberNameView
                .padding(.horizontal, DynamicLayout.dynamicValuebyWidth(97))
            
            teamMemberGridView
        }
        .ignoresSafeArea(edges: .top)
    }
    
    private var navigationTopView: some View {
        ZStack(alignment: .bottom) {
            RoundedCornerShape(
                radius: DynamicLayout.dynamicValuebyWidth(10), corners: [.bottomLeft, .bottomRight]
            )
            .fill(selectedTheme.primaryColor)
            .frame(maxWidth: .infinity)
            .frame(height: DynamicLayout.dynamicValuebyHeight(115))
            
            CustomNavigationBar(
                title: { Text("선수 교체") },
                
                leading: {
                    Button {
                        router.pop()
                    } label: {
                        Image(systemName: "chevron.left")
                    }
                },
                
                trailing: {
                    Button {
                        router.pop()
                    } label: {
                        Text("완료")
                    }
                }
            )
        }
    }
    
    private var selectedMemberNameView: some View {
        GeometryReader { geometry in
            let totalWidth = geometry.size.width
            let selectWidth = totalWidth / 2
            
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: DynamicLayout.dynamicValuebyWidth(10))
                    .fill(Color.white)
                    .stroke(Color.gray03, lineWidth: DynamicLayout.dynamicValuebyWidth(1))
                
                RoundedCornerShape(
                    radius: DynamicLayout.dynamicValuebyWidth(10),
                    corners: [.topLeft, .bottomLeft]
                )
                .fill(Color.white)
                .stroke(Color.gray03, lineWidth: DynamicLayout.dynamicValuebyWidth(1))
                .frame(width: selectWidth)
                
                HStack(spacing: 0) {
                    Text("기존 선수")
                        .frame(width: selectWidth)
                        .font(.dynamicPretend(type: .semibold, size: 16))
                        .foregroundStyle(
                            Color.black
                        )
                    
                    Text(changeForPlayer.name)
                        .frame(width: selectWidth)
                        .font(.dynamicPretend(type: .semibold, size: 16))
                        .foregroundStyle(
                            selectedTheme.primaryColor
                        )
                }
            }
        }
        .frame(height: DynamicLayout.dynamicValuebyHeight(42))
    }
    
    let columns: [GridItem] = Array(repeating: .init(.flexible(), spacing: DynamicLayout.dynamicValuebyWidth(20)), count: 2)
    
    private var teamMemberGridView: some View {
        VStack(alignment: .leading, spacing: DynamicLayout.dynamicValuebyHeight(10)) {
            Text("교체 선수")
                .font(.dynamicPretend(type: .semibold, size: 16))
                .foregroundStyle(Color.gray05)
                .padding(.leading, 37)
            
            ScrollView(.vertical, showsIndicators: false) {
                LazyVGrid(columns: columns, spacing: DynamicLayout.dynamicValuebyHeight(18)) {
                    ForEach($backupMembers, id: \.id) { $backupMember in
                        ChangeMemberNameCell(selectedTheme: selectedTheme, player: backupMember, action: {
                            selectedPlayer = backupMember
                        }, selected: selectedPlayer?.id == backupMember.id)
                        .frame(height: DynamicLayout.dynamicValuebyHeight(60))
                    }
                }
            }
            .contentMargins(.horizontal, 37)
            .contentMargins(.top, DynamicLayout.dynamicValuebyHeight(2))
            .contentMargins(.bottom, DynamicLayout.dynamicValuebyHeight(12))
        }
    }
}
