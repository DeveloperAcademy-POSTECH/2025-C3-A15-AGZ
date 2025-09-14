//
//  NavigationRouter.swift
//  CheerLot
//
//  Created by 이현주 on 6/1/25.
//

import SwiftUI

/// SwiftUI에서 상태를 추적할 수 있도록 Observable로 선언된 라우터 클래스
@Observable
class NavigationRouter: NavigationRoutable {

  /// 네비게이션 스택 상태
  var destination: [NavigationDestination] = []

  /// 화면을 새로 추가 (푸시)
  func push(to view: NavigationDestination) {
    destination.append(view)
  }

  /// 마지막 화면을 제거 (뒤로가기)
  func pop() {
    _ = destination.popLast()
  }

  /// 스택초기화
  func popToRootView() {
    destination.removeAll()
  }
}
