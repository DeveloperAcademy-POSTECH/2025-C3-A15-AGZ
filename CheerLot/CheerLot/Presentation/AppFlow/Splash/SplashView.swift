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
  @EnvironmentObject var remoteConfigChecker: RemoteConfigChecker

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

          await remoteConfigChecker.fetchRemoteConfig()

          if remoteConfigChecker.isServerChecking {
            return
          } else if !remoteConfigChecker.shouldForceUpdate {  // 업데이트 필요 없을 시, 메인으로 이동
            withAnimation { isVideoFinished = true }
            await appFlowViewModel.changeAppState(.main)
          }
        }
        // foreground로 복귀할 때마다 checkVersion 함수를 실행
        .onReceive(
          NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)
        ) { _ in
          Task {
            await remoteConfigChecker.fetchRemoteConfig()
          }
        }
    }
    .alert("최신 업데이트 안내", isPresented: $remoteConfigChecker.shouldForceUpdate) {
      Button("확인") {
        if let url = URL(string: "itms-apps://itunes.apple.com/app/id6748527115") {
          UIApplication.shared.open(url)
        }
      }
    } message: {
      Text("안정적인 서비스 사용을 위해\n최신 버전으로 업데이트해 주세요")
    }
    .alert("서비스 점검 안내", isPresented: $remoteConfigChecker.isServerChecking) {
      Button("확인") {
        UIApplication.shared.perform(#selector(NSXPCConnection.suspend))  // 앱을 suspend 상태로 만들기
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {  // 실질적인 앱 종료 부분
          exit(0)
        }
      }
    } message: {
      Text(remoteConfigChecker.serverCheckingMessage)
    }
  }
}
