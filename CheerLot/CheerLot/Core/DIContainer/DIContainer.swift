//
//  DIContainer.swift
//  CheerLot
//
//  Created by 이승진 on 9/5/25.
//

import Foundation

/// 앱 전역에서 사용할 의존성 주입(Dependency Injection) 컨테이너 클래스
class DIContainer: ObservableObject {

  /// 화면 전환을 제어하는 네비게이션 라우터
  @Published var navigationRouter: NavigationRouter

  init(
    navigationRouter: NavigationRouter = .init(),
  ) {
    self.navigationRouter = navigationRouter
  }
}
