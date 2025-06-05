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

  @Bindable var viewModel: CheerSongViewModel = .init()

  var body: some View {
    ZStack {
      Image(.ssCheerSongBG)
        .resizable()
        .scaledToFill()
        .ignoresSafeArea()

      VStack(spacing: 0) {
        CustomNavigationBar(showBackButton: true)

        VStack {
          cheerSongTitle
          lyricsView
          progressView
          controlView
        }
        .padding(.horizontal, 36)
      }
    }
    .ignoresSafeArea(.all)
    .onAppear {
      viewModel.configurePlaylist(with: players, startAt: startIndex)
      viewModel.onSongDidFinish = {
        viewModel.playNext()
      }
    }
    .onDisappear {
      viewModel.cleanup()
    }
  }

  /// 헬멧 이미지 + 타이틀
  private var cheerSongTitle: some View {
    HStack(spacing: 0) {
      Image(.ssHat)
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
    ScrollView {
      LazyVStack(alignment: .leading, spacing: 0) {
        Text(viewModel.lyricsLines)
          .multilineTextAlignment(.leading)
          .lineHeightMultipleAdaptPretend(fontType: .bold, fontSize: 28, lineHeight: 1.7)
          .foregroundColor(.white)
      }
      .frame(maxWidth: .infinity)
    }
  }

  // MARK: - 프로그레스 뷰
  private var progressView: some View {
    VStack {
      Slider(
        value: $viewModel.progress, in: 0...viewModel.duration,
        onEditingChanged: { editing in
          if !editing {
            viewModel.seek(to: viewModel.progress)
          }
        }
      )
      .tint(.white)

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
        viewModel.playPrevious()
      } label: {
        Image(.backwardPlay)
          .resizable()
          .aspectRatio(contentMode: .fit)
          .frame(width: 26.7, height: 23.94)
      }

      Button {
        viewModel.togglePlayback()
      } label: {
        Image(systemName: viewModel.isPlaying ? "pause.fill" : "play.fill")
          .resizable()
          .aspectRatio(contentMode: .fit)
          .frame(width: 32, height: 32)
          .foregroundStyle(.white)
      }

      Button {
        viewModel.playNext()
      } label: {
        Image(.forwardPlay)
          .resizable()
          .aspectRatio(contentMode: .fit)
          .frame(width: 26.7, height: 23.94)
      }
    }
    .foregroundColor(.white)
    .padding(.bottom, 48)
  }
}
