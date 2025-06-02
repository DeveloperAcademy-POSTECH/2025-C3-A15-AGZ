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

// MARK: - lineHeight Multiple, letterSpacing 적용 Text 커스텀 수정자
// Text("Hello world!")
//    .lineHeightMultipleAdaptPretend(fontType: .semibold, fontSize: 12, lineHeight: 1.2)

// Text("Hello world!")
//    .lineHeightMultipleAdaptFreshman(fontSize: 33, lineHeight: 1.15)

// Text에 multiple로 line height와 letter spacing을 적용할 수 있습니다.
// letterSpacing은 적용되지 않은 경우도 많아서 default값을 0으로 뒀습니다
// 120% -> 1.2 / - 5% -> -0.05 로 파라미터에 넣으면 됩니다.
