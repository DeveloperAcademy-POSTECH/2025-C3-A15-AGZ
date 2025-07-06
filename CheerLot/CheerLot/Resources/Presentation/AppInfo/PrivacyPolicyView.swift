//
//  PrivacyPolicyView.swift
//  CheerLot
//
//  Created by 이현주 on 7/6/25.
//

import SwiftUI

struct PrivacyPolicyView: View {
    var body: some View {
        VStack(spacing: DynamicLayout.dynamicValuebyHeight(15)) {
            CustomNavigationBar(
                showBackButton: true,
                title: { Text("개인정보 처리방침") },
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
    PrivacyPolicyView()
}
