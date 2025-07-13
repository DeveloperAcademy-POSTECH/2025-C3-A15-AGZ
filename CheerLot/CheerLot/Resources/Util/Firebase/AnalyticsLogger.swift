//
//  AnalyticsLogger.swift
//  CheerLot
//
//  Created by 이현주 on 7/12/25.
//

import FirebaseAnalytics
import Foundation

public struct AnalyticsLogger {
  /// 화면 진입 시 Firebase screen view 로그
  static func logScreen(_ name: String, file: String = #file) {
    let sanitizedFile = (file as NSString).lastPathComponent.prefix(100)
    Analytics.logEvent(
      "CHEERLOT_ViewAppear",
      parameters: [
        "screen_name": name,
        "screen_class": name,
        "file_name": String(sanitizedFile),
      ])
  }

  /// 버튼 클릭 이벤트 로그
  static func logButtonClick(screen: String, button: String, file: String = #file) {
    let sanitizedFile = (file as NSString).lastPathComponent.prefix(100)
    Analytics.logEvent(
      "CHEERLOT_Button_Clicked",
      parameters: [
        "screen_name": screen,
        "button_name": button,
        "file_name": String(sanitizedFile),
      ])
  }

  /// 셀 클릭 이벤트 로그
  static func logCellClick(screen: String, cell: String, index: Any? = nil, file: String = #file) {
    let sanitizedFile = (file as NSString).lastPathComponent.prefix(100)
    var params: [String: Any] = [
      "screen_name": screen,
      "cell_name": cell,
      "file_name": String(sanitizedFile),
    ]
    if let index = index {
      params["index"] = index
    }
    Analytics.logEvent("CHEERLOT_Cell_Clicked", parameters: params)
  }
}
