//
//  NavigationRoutingView.swift
//  CheerLot
//
//  Created by 이승진 on 9/5/25.
//

import SwiftUI

/// 앱 내에서 특정 화면으로의 이동을 처리하는 라우팅 뷰입니다.
/// `NavigationDestination` enum 값을 기준으로 적절한 화면을 렌더링합니다.
struct NavigationRoutingView: View {
  
  /// DI 컨테이너: 의존성 주입을 위한 환경 객체
  @EnvironmentObject var container: DIContainer
  
  /// 현재 이동할 화면을 나타내는 상태값
  @State var destination: NavigationDestination
  
  // MARK: - Body
  var body: some View {
    
      switch destination {
      case .teamRoaster:
        TeamRoasterView()
        
      case .changeMemeber(let selectedPlayer):
        ChangeStartingMemberView()
        
      case .playCheerSong(let players, let startIndex):
        CheerSongView(players: players, startIndex: startIndex)
        
      case .appInfo:
        MainAppInfoView()
        
        // 설정 관련 라우팅
      case .termsOfService:
        AppInfoTextPageView(title: "이용약관", text: Constants.AppInfo.termsOfService)
          .toolbar(.hidden)
      case .privacyPolicy:
        AppInfoTextPageView(title: "개인정보 처리방침", text: Constants.AppInfo.privacyPolicy)
          .toolbar(.hidden)
      case .copyright:
        AppInfoTextPageView(title: "저작권 법적고지", text: Constants.AppInfo.copyrightPolicy)
          .toolbar(.hidden)
      case .aboutMaker:
        AboutMakerView()
          .toolbar(.hidden)
      }
    
    // 각 하위 뷰에도 DIContainer를 공유해줌
    .environmentObject(container) 
  }
}
