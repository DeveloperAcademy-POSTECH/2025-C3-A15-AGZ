//
//  View+.swift
//  WatchCheerLot Watch App
//
//  Created by 이현주 on 6/2/25.
//

import Foundation
import SwiftUI

extension View {
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
