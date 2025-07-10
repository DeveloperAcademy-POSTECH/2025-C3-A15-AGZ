//
//  SplashView.swift
//  CheerLot
//
//  Created by 이승진 on 7/10/25.
//

import SwiftUI
import AVKit

/// 앱 실행시 보여주는 스플래시 화면
struct SplashView: View {
    
    // MARK: - Property
    @EnvironmentObject private var themeManager: ThemeManager
    @EnvironmentObject private var router: NavigationRouter
    
    @State private var isVideoFinished = false
    private let player = AVPlayer(url: Bundle.main.url(forResource: "splash", withExtension: "mp4")!)
    
    // MARK: - Constants
    fileprivate enum SplashConstants {
        static let timeNanoSeconds: UInt64 = 1_250_000_000 // 1.25초
    }
    
    // MARK: - Body
    var body: some View {
            if isVideoFinished {
                RootView()
                    .environmentObject(themeManager)
                    .environmentObject(router)
            } else {
                VideoPlayer(player: player).ignoresSafeArea()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .task {
                        player.play()
                        
                        try? await Task.sleep(nanoseconds: SplashConstants.timeNanoSeconds)
                        withAnimation {
                            isVideoFinished = true
                        }
                    }
            }
    }
}

#Preview {
    SplashView()
}
