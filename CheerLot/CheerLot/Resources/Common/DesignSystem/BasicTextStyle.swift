//
//  BasicTextStyle.swift
//  CheerLot
//
//  Created by 이현주 on 5/31/25.
//

import SwiftUI

// Pretend, lineHeight: 120%, letterSpcing: -5% 기본 style Text 커스텀 수정자
struct BasicTextStyle: ViewModifier {
  let fontType: Font.Pretend
  let fontSize: CGFloat

  func body(content: Content) -> some View {
    content
      .font(Font.dynamicPretend(type: fontType, size: fontSize))
      .kerning(fontSize * -0.05)
      .lineSpacing(fontSize * 1.2 - fontSize)
      .padding(.vertical, (fontSize * 1.2 - fontSize) / 2)
  }
}

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
