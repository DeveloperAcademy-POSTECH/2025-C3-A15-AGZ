//
//  SplashView.swift
//  CheerLot
//
//  Created by 이승진 on 7/10/25.
//

import AVKit
import SwiftUI

/// 앱 실행시 보여주는 스플래시 화면
struct SplashView: View {
  @EnvironmentObject private var themeManager: ThemeManager
  @EnvironmentObject private var appFlowViewModel: AppFlowViewModel

  @State private var isVideoFinished = false
  private let player = AVPlayer(url: Bundle.main.url(forResource: "splash", withExtension: "mp4")!)

  private enum SplashConstants {
    static let timeNanoSeconds: UInt64 = 1_250_000_000  // 1.25s
  }

  var body: some View {
    Group {
      VideoPlayer(player: player)
        .disabled(true)
        .overlay(Color.clear)
        .ignoresSafeArea()
        .task {
          player.play()
          try? await Task.sleep(nanoseconds: SplashConstants.timeNanoSeconds)
          withAnimation { isVideoFinished = true }
          await appFlowViewModel.changeAppState(.main)
        }
    }
  }
}
