//
//  NavigationRoutable.swift
//  CheerLot
//
//  Created by 이승진 on 9/5/25.
//

import Foundation

/// 화면 이동을 제어하기 위한 라우팅 프로토콜
protocol NavigationRoutable {

  /// 현재 네비게이션 스택에 쌓여 있는 목적지들
  var destination: [NavigationDestination] { get set }

  /// 새로운 화면을 네비게이션 스택에 푸시
  func push(to view: NavigationDestination)

  /// 현재 화면을 팝 (뒤로 가기)
  func pop()

  /// 루트 화면까지 모두 팝 (처음 화면으로 이동)
  func popToRootView()
}
