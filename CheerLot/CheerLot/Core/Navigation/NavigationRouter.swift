//
//  NavigationRouter.swift
//  CheerLot
//
//  Created by 이현주 on 6/1/25.
//

import SwiftUI

//class NavigationRouter: ObservableObject {
//  @Published var path = NavigationPath()  // 네비게이션 경로를 저장하는 변수
//
//  /// 특정 화면을 추가 (Push 기능)
//  func push(_ route: MainRoute) {
//    path.append(route)
//  }
//
//  /// 마지막 화면 제거 (Pop 기능)
//  func pop() {
//    if !path.isEmpty {
//      path.removeLast()
//    }
//  }
//
//  /// 네비게이션 초기화 (전체 Pop)
//  func reset() {
//    path = NavigationPath()
//  }
//}

/// SwiftUI에서 상태를 추적할 수 있도록 Observable로 선언된 라우터 클래스
@Observable
class NavigationRouter: NavigationRoutable {
    
    /// 현재까지 쌓인 화면 목적지 목록 (화면 전환 상태)
    var destination: [NavigationDestination] = []
    
    /// 화면을 새로 추가 (푸시)
    /// - Parameter view: 이동할 화면을 나타내는 NavigationDestination
    func push(to view: NavigationDestination) {
        destination.append(view)
    }
    
    /// 마지막 화면을 제거 (뒤로 가기)
    func pop() {
        _ = destination.popLast()
    }
    
    /// 스택을 초기화하여 루트 화면으로 이동
    func popToRootView() {
        destination.removeAll()
    }
}
