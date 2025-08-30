//
//  BasicTextStyle.swift
//  WatchCheerLot Watch App
//
//  Created by 이현주 on 6/2/25.
//

import SwiftUI

// Pretend, lineHeight Multiple, letterSpacing 적용 Text 커스텀 수정자
struct LineHeightMultipleAdaptPretend: ViewModifier {
  let fontType: Font.Pretend
  let fontSize: CGFloat
  let lineHeight: CGFloat
  let letterSpacing: CGFloat

  func body(content: Content) -> some View {
    content
      .font(Font.dynamicPretend(type: fontType, size: fontSize))
      .kerning(fontSize * letterSpacing)
      .lineSpacing(fontSize * lineHeight - fontSize)
      .padding(.vertical, (fontSize * lineHeight - fontSize) / 2)
  }
}

// Freshman, lineHeight Multiple, letterSpacing 적용 Text 커스텀 수정자
struct LineHeightMultipleAdaptFreshman: ViewModifier {
  let fontSize: CGFloat
  let lineHeight: CGFloat
  let letterSpacing: CGFloat

  func body(content: Content) -> some View {
    content
      .font(Font.dynamicFreshman(size: fontSize))
      .kerning(fontSize * letterSpacing)
      .lineSpacing(fontSize * lineHeight - fontSize)
      .padding(.vertical, (fontSize * lineHeight - fontSize) / 2)
  }
}
