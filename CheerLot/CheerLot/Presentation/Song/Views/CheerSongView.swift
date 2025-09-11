//
//  CheerSongView.swift
//  CheerLot
//
//  Created by 이승진 on 6/1/25.
//

import AVFoundation
import SwiftUI

struct CheerSongView: View {

  let players: [Player]
  let startIndex: Int
  let theme: Theme = ThemeManager.shared.currentTheme
  var screenName: String = LoggerEvent.View.playCheerSongV

  @EnvironmentObject var container: DIContainer
  @Bindable var viewModel: CheerSongViewModel = .init()
  @State private var networkMonitor = NetworkMonitor()
  @State private var showNetworkAlert = false

  var body: some View {
    ZStack {
      theme.cheerSongBackground
        .resizable()
        .scaledToFill()
        .ignoresSafeArea()

      VStack {
        cheerSongTitle
        lyricsView
        progressView
        controlView
      }
      .padding(.vertical, 56)
      .padding(.horizontal, 36)
    }
    //    .ignoresSafeArea(.all)
    .navigationBarBackButtonHidden(true)
    .customNavigation(
      leadingAction: { container.navigationRouter.pop() },
      whiteStyle: true
    )
    .onAppear {
      AnalyticsLogger.logScreen(screenName)
      viewModel.configurePlaylist(with: players, startAt: startIndex)
      viewModel.onSongDidFinish = {
        viewModel.playNext()
      }
    }
    .onDisappear {
      viewModel.cleanup()
    }
    .onChange(of: networkMonitor.isConnected) { _, isConnected in
      if !isConnected {
        showNetworkAlert = true
      }
    }
    .alert("네트워크 연결 오류", isPresented: $showNetworkAlert) {
      Button("확인", role: .cancel) {
        AnalyticsLogger.logButtonClick(
          screen: screenName, button: LoggerEvent.ButtonEvent.alertAcceptBtnTapped)
      }
    } message: {
      Text("네트워크 연결 상태 확인 후\n다시 시도해 주세요")
    }
  }

  /// 헬멧 이미지 + 타이틀
  private var cheerSongTitle: some View {
    HStack(spacing: 0) {
      theme.cheerSongHatImage
        .resizable()
        .aspectRatio(contentMode: .fit)
        .frame(width: 80, height: 80)

      VStack(alignment: .leading, spacing: 2) {
        Text(viewModel.playerName)
          .font(.dynamicPretend(type: .bold, size: 18))
          .foregroundStyle(.white)

        Text(viewModel.title)
          .font(.dynamicPretend(type: .regular, size: 14))
          .foregroundStyle(.white)
      }

      Spacer()
    }
  }

  /// 가사 뷰
  private var lyricsView: some View {
    ScrollView(showsIndicators: true) {
      LazyVStack(alignment: .leading, spacing: 0) {
        Text(viewModel.lyricsLines)
          .multilineTextAlignment(.leading)
          .lineHeightMultipleAdaptPretend(fontType: .bold, fontSize: 28, lineHeight: 1.7)
          .foregroundColor(.white)
      }
      .padding(.horizontal, 12)
    }
  }

  // MARK: - 프로그레스 뷰
  private var progressView: some View {
    VStack(spacing: 4) {
      CustomSeekBar(
        value: $viewModel.progress,
        maxValue: viewModel.duration
      ) { newTime in
        viewModel.seek(to: newTime)
      }
      .frame(height: 12)
      .padding(.vertical, 4)

      HStack {
        Text(viewModel.progress.asTimeString)
        Spacer()
        Text((viewModel.duration - viewModel.progress).asTimeString)
      }
      .font(.dynamicPretend(type: .medium, size: 13))
      .foregroundColor(.white)
    }
    .padding(.bottom, 20)
  }

  /// 재생 컨트롤 뷰
  private var controlView: some View {
    HStack(spacing: 40) {
      Button {
        AnalyticsLogger.logButtonClick(
          screen: screenName, button: LoggerEvent.ButtonEvent.beforeBtnTapped)
        viewModel.playPrevious()
      } label: {
        Image(.backwardPlay)
          .resizable()
          .aspectRatio(contentMode: .fit)
          .frame(width: 26.7, height: 23.94)
      }

      Button {
        AnalyticsLogger.logButtonClick(
          screen: screenName, button: LoggerEvent.ButtonEvent.playBtnTapped)
        viewModel.togglePlayback()
      } label: {
        Image(systemName: viewModel.isPlaying ? "pause.fill" : "play.fill")
          .resizable()
          .aspectRatio(contentMode: .fit)
          .frame(width: 32, height: 32)
          .foregroundStyle(.white)
      }

      Button {
        AnalyticsLogger.logButtonClick(
          screen: screenName, button: LoggerEvent.ButtonEvent.nextBtnTapped)
        viewModel.playNext()
      } label: {
        Image(.forwardPlay)
          .resizable()
          .aspectRatio(contentMode: .fit)
          .frame(width: 26.7, height: 23.94)
      }
    }
    .foregroundColor(.white)
    .padding(.bottom, 70)
  }
}
