//
//  Font+.swift
//  WatchCheerLot Watch App
//
//  Created by 이현주 on 6/2/25.
//

import Foundation
import SwiftUI

extension Font {
  enum Pretend {
    case extraBold
    case bold
    case semibold
    case medium
    case regular
    case light

    var value: String {
      switch self {
      case .extraBold:
        return "Pretendard-ExtraBold"
      case .bold:
        return "Pretendard-Bold"
      case .semibold:
        return "Pretendard-SemiBold"
      case .medium:
        return "Pretendard-Medium"
      case .regular:
        return "Pretendard-Regular"
      case .light:
        return "Pretendard-Light"
      }
    }
  }

  static func pretend(type: Pretend, size: CGFloat) -> Font {
    return .custom(type.value, size: size)
  }

  // 동적 pretend
  static func dynamicPretend(type: Pretend, size: CGFloat) -> Font {
    let scaledSize = WatchDynamicLayout.dynamicValuebyWidth(size)
    return .custom(type.value, size: scaledSize)
  }

  static func freshman(size: CGFloat) -> Font {
    return .custom("Freshman", size: size)
  }

  // 동적 freshman
  static func dynamicFreshman(size: CGFloat) -> Font {
    let scaledSize = WatchDynamicLayout.dynamicValuebyWidth(size)
    return .custom("Freshman", size: scaledSize)
  }
}
