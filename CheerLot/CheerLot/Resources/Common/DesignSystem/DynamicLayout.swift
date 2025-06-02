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

  // 전체 너비
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

// MARK: - 동적 layout 값 변환
// 디자인 화면 크기 대비 기기 화면크기 비율을 기준으로 padding, frame, font 등의 값에 적용합니다.
// vertical padding이나 width, font 등 - DynamicLayout.dynamicValuebyWidth(10)
// horizontal padding이나 height 등 - DynamicLayout.dynamicValuebyHeight(10)
// 등 상수를 사용하는 상황마다 감싸서 사용합니다
