//
//  AppFlowViewModel.swift
//  CheerLot
//
//  Created by 이승진 on 9/9/25.
//

import Foundation

/// 앱의 전체 흐름을 제어하는 뷰모델
class AppFlowViewModel: ObservableObject {

  /// 앱의 현재 상태를 나타냄 (Splash, Main)
  @Published private(set) var appState: AppState = .splash

  /// 앱의 상태를 나타내는 열거형
  enum AppState {
    case splash
    case main
  }

  /// 앱 상태를 외부에서 변경하는 함수
  @MainActor
  public func changeAppState(_ newState: AppState) async {
    self.appState = newState
  }
}
