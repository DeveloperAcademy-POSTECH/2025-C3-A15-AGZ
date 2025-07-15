//
//  View+.swift
//  CheerLot
//
//  Created by 이현주 on 5/31/25.
//

import SwiftUI

extension View {
  //특정 corner radius 적용 함수
  func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
    clipShape(RoundedCornerShape(radius: radius, corners: corners))
  }

  // 기본 style Text 커스텀 수정자 적용 함수
  func basicTextStyle(fontType: Font.Pretend, fontSize: CGFloat) -> some View {
    self.modifier(BasicTextStyle(fontType: fontType, fontSize: fontSize))
  }

  // pretend에 line height multiple와 letter spacing 수정자 적용 함수
  func lineHeightMultipleAdaptPretend(
    fontType: Font.Pretend, fontSize: CGFloat, lineHeight: CGFloat, letterSpacing: CGFloat = 0
  ) -> some View {
    self.modifier(
      LineHeightMultipleAdaptPretend(
        fontType: fontType, fontSize: fontSize, lineHeight: lineHeight, letterSpacing: letterSpacing
      ))
  }

  // freshman에 line height multiple와 letter spacing 수정자 적용 함수
  func lineHeightMultipleAdaptFreshman(
    fontSize: CGFloat, lineHeight: CGFloat, letterSpacing: CGFloat = 0
  ) -> some View {
    self.modifier(
      LineHeightMultipleAdaptFreshman(
        fontSize: fontSize, lineHeight: lineHeight, letterSpacing: letterSpacing))
  }
}
