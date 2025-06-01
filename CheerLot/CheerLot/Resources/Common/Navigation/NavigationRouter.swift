//
//  NavigationRouter.swift
//  CheerLot
//
//  Created by 이현주 on 6/1/25.
//

import SwiftUI

class NavigationRouter: ObservableObject {
    @Published var path = NavigationPath() // 네비게이션 경로를 저장하는 변수
    
    /// 특정 화면을 추가 (Push 기능)
    func push(_ route: MainRoute) {
        path.append(route)
    }
    
    /// 마지막 화면 제거 (Pop 기능)
    func pop() {
        if !path.isEmpty {
            path.removeLast()
        }
    }
    
    /// 네비게이션 초기화 (전체 Pop)
    func reset() {
        path = NavigationPath()
    }
}
