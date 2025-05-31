//
//  DynamicPadding.swift
//  CheerLot
//
//  Created by 이현주 on 5/31/25.
//

import SwiftUI

public struct DynamicLayout {

  // 전체 화면 크기
  public static var screenSize: CGRect {
    guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
      return .zero
    }
    return windowScene.screen.bounds
  }

  // 너비
  public static var superWidth: CGFloat {
    screenSize.width
  }

  // 전체 높이
  public static var superHeight: CGFloat {
    screenSize.height
  }

  // 기준 너비 기반 크기 변환
  public static func dynamicValuebyWidth(_ base: CGFloat) -> CGFloat {
    base * (superWidth / 393)
  }

  // 기준 높이 기반 크기 변환
  public static func dynamicValuebyHeight(_ base: CGFloat) -> CGFloat {
    base * (superHeight / 852)
  }
}
