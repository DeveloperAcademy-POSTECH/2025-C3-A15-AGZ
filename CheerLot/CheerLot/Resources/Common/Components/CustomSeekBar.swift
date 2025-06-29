//
//  CustomSeekBar.swift
//  CheerLot
//
//  Created by 이승진 on 6/8/25.
//

import SwiftUI

struct CustomSeekBar: View {
  @Binding var value: Double  // 현재 시간
  let maxValue: Double  // 전체 시간
  let onSeek: (Double) -> Void  // 사용자 터치 후 실제 시킹

  var body: some View {
    GeometryReader { geometry in
      let width = geometry.size.width
      let height: CGFloat = 5
      let progress = max(0, min(1, value / maxValue))
      let dragWidth = width * progress

      ZStack(alignment: .leading) {
        Capsule()
          .fill(Color.gray04.opacity(0.30))
          .frame(height: height)

        Capsule()
          .fill(Color.white)
          .frame(width: dragWidth, height: height)
      }
      .frame(height: height)
      .contentShape(Rectangle())  // 탭 가능한 영역 확보
      .gesture(
        DragGesture(minimumDistance: 0)
          .onChanged { gesture in
            let location = gesture.location.x
            let percent = max(0, min(1, location / width))
            value = percent * maxValue
          }
          .onEnded { gesture in
            let location = gesture.location.x
            let percent = max(0, min(1, location / width))
            let newTime = percent * maxValue
            onSeek(newTime)
          }
      )
    }
    .frame(height: 12)
  }
}
