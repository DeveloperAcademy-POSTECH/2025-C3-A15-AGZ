//
//  CopyrightView.swift
//  CheerLot
//
//  Created by 이현주 on 7/6/25.
//

import SwiftUI

struct CopyrightView: View {
    var body: some View {
        VStack(spacing: DynamicLayout.dynamicValuebyHeight(15)) {
            CustomNavigationBar(
                showBackButton: true,
                title: { Text("저작권 약관") },
                tintColor: .black
            )
            
            VStack(spacing: DynamicLayout.dynamicValuebyHeight(0)) {
                
                Spacer()
            }
            .padding(.horizontal, DynamicLayout.dynamicValuebyWidth(0))
        }
        .ignoresSafeArea()
    }
}

#Preview {
    CopyrightView()
}
