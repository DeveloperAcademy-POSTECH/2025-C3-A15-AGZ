//
//  WatchDynamicLayout.swift
//  WatchCheerLot Watch App
//
//  Created by 이현주 on 6/2/25.
//

import SwiftUI
import WatchKit

public struct WatchDynamicLayout {

  // 현재 기기 화면 전체 크기
  private static var currentScreenSize: CGSize = WKInterfaceDevice.current().screenBounds.size

  // 전체 너비
  public static var superWidth: CGFloat {
    currentScreenSize.width
  }

  // 전체 높이
  public static var superHeight: CGFloat {
    currentScreenSize.height
  }

  public static func dynamicValuebyWidth(_ base: CGFloat) -> CGFloat {
    base * (superWidth / 184)
  }

  public static func dynamicValuebyHeight(_ base: CGFloat) -> CGFloat {
    base * (superHeight / 224)
  }
}
