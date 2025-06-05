//
//  StartView.swift
//  CheerLot
//
//  Created by theo on 6/4/25.
//

import SwiftUI

struct StartView: View {
    var body: some View {
        ZStack {
            // 전체 배경
            Color.black
                .ignoresSafeArea()

            // 중앙 알림 팝업
            VStack(spacing: WatchDynamicLayout.dynamicValuebyWidth(8)) {
                Text("직관 집중 ON")
                    .font(.dynamicPretend(type: .semibold, size: WatchDynamicLayout.dynamicValuebyWidth(15)))
                Text("방해금지 모드를 켜주세요")
                    .font(.dynamicPretend(type: .medium, size: WatchDynamicLayout.dynamicValuebyWidth(12)))
                    .foregroundColor(Color(red: 177/255, green: 177/255, blue: 177/255))
            }
            .background(Color.black.opacity(0.85))
        }
    }
}

struct StartView_Previews: PreviewProvider {
    static var previews: some View {
        StartView()
    }
}
