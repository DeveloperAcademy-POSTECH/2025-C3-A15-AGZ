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
      Rectangle()
        .fill(.ultraThinMaterial)
        .ignoresSafeArea()

      // 중앙 알림 팝업
      VStack(spacing: WatchDynamicLayout.dynamicValuebyHeight(8)) {
        Text("직관 집중 ON")
          .font(.dynamicPretend(type: .bold, size: 15))
        Text("방해금지 모드를 켜주세요")
          .font(.dynamicPretend(type: .medium, size: 12))
          .foregroundColor(Color.gray04)
      }
    }
  }
}

struct StartView_Previews: PreviewProvider {
  static var previews: some View {
    StartView()
  }
}
