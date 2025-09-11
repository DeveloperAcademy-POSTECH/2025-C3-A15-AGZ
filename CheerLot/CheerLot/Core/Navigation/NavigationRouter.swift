//
//  NavigationRouter.swift
//  CheerLot
//
//  Created by 이현주 on 6/1/25.
//

import SwiftUI

/// SwiftUI에서 상태를 추적할 수 있도록 Observable로 선언된 라우터 클래스
@Observable
class NavigationRouter {
  
  /// 네비게이션 스택 상태
  var path = NavigationPath()
  
  /// 화면을 새로 추가 (푸시)
  /// - Parameter view: 이동할 화면을 나타내는 NavigationDestination
  func push(_ dest: NavigationDestination) {
    path.append(dest)
  }
  
  func pop() {
    guard !path.isEmpty else { return }
    path.removeLast()
  }
  
  func popToRoot() {
    guard !path.isEmpty else { return }
    path.removeLast(path.count)
  }
}
