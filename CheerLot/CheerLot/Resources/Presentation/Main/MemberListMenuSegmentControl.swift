//
//  MemberListMenuSegmentControl.swift
//  CheerLot
//
//  Created by 이현주 on 5/31/25.
//

import SwiftUI

struct MemberListMenuSegmentControl: View {

  @Binding var selectedSegment: MemberListMenuSegment
  let selectedTheme: Theme
  var screenName: String = LoggerEvent.View.mainRoasterV

  var body: some View {
    GeometryReader { geometry in
      let totalWidth = geometry.size.width
      let selectWidth = totalWidth / CGFloat(MemberListMenuSegment.allCases.count)

      ZStack(alignment: .leading) {
        RoundedRectangle(cornerRadius: DynamicLayout.dynamicValuebyWidth(10))
          .fill(Color.gray01)
          .stroke(Color.gray03, lineWidth: 1)

        RoundedCornerShape(
          radius: DynamicLayout.dynamicValuebyWidth(10),
          corners: selectedSegment == .starting
            ? [.topLeft, .bottomLeft] : [.topRight, .bottomRight]
        )
        .fill(Color.white)
        .stroke(Color.gray03, lineWidth: 1)
        .frame(width: selectWidth)
        .offset(x: CGFloat(selectedSegment.rawValue) * selectWidth)

        HStack(spacing: 0) {
          ForEach(MemberListMenuSegment.allCases) { segment in
            Button(
              action: {
                selectedSegment = segment
                AnalyticsLogger.logCellClick(
                  screen: screenName, cell: LoggerEvent.CellEvent.listTypeTapped, index: segment.id)
              },
              label: {
                Text(segment.title)
                  .frame(width: selectWidth)
                  .basicTextStyle(
                    fontType: selectedSegment == segment ? .bold : .semibold,
                    fontSize: 16
                  )
                  .foregroundStyle(
                    selectedSegment == segment ? selectedTheme.primaryColor01 : Color.gray04
                  )
              })
          }
        }
      }
    }
    .frame(height: DynamicLayout.dynamicValuebyHeight(42))
  }
}

//#Preview {
//    MemberListMenuSegmentControl()
//}
