//
//  CheerSongView.swift
//  CheerLot
//
//  Created by 이승진 on 6/1/25.
//

import AVFoundation
import SwiftUI

struct CheerSongView: View {
  let title = "류지혁"
  let subTitle = "안타송"

  /// 임시 가사, 추후 바꿀 예정
  private var lyricsLines: [String] {
    [
      "류지혁 워어어어",
      "날려버려 워어어어",
      "시원하고 화끈하게",
      "류지혁 류지혁 워어어어",
      "삼성 류지혁 최강삼성",
      "승리를 위해 류지혁",
    ]
  }

  @Bindable var viewModel: CheerSongViewModel = .init()

  @State private var isPlaying = false
  @State private var progress: Double = 30.0
  let duration: Double = 45.0

  var body: some View {
    ZStack {
      Image(.ssCheerSongBG)
        .resizable()
        .ignoresSafeArea()

      VStack {
        navigationBar

        VStack {
          cheerSongTitle

          Spacer()

          lyricsView

          Spacer()

          progressView

          controlView
        }
        .padding(EdgeInsets(top: 0, leading: 36, bottom: 0, trailing: 36))
      }
    }
    .ignoresSafeArea()
  }

  /// 네비게이션바
  private var navigationBar: some View {
    CustomNavigationBar(
      leading: {
        Button {
        } label: {
          Image(systemName: "chevron.left")
        }
      }
    )
  }

  /// 헬멧 이미지 + 선수 이름 + 노래 종류 타이틀
  private var cheerSongTitle: some View {
    HStack(spacing: 0) {
      Image(.ssHat)
        .resizable()
        .aspectRatio(contentMode: .fit)
        .frame(width: 80, height: 80)

      VStack(alignment: .leading, spacing: 2) {
        Text(title)
          .font(.dynamicPretend(type: .bold, size: 18))
          .foregroundStyle(.white)

        Text(subTitle)
          .font(.dynamicPretend(type: .regular, size: 14))
          .foregroundStyle(.white)
      }

      Spacer()
    }
    .padding(.bottom, 40)
  }

  /// 가사 띄워주는 뷰
  private var lyricsView: some View {
    VStack(alignment: .leading, spacing: 0) {
      ForEach(lyricsLines, id: \.self) { line in
        Text(line)
          .lineHeightMultipleAdaptPretend(fontType: .bold, fontSize: 28, lineHeight: 1.9)
          .foregroundColor(.white)
      }

      Spacer()
    }
    .multilineTextAlignment(.center)
  }

  /// 재생 프로그레스바 + 시간을 나타내는 뷰
  private var progressView: some View {
    VStack {
      Slider(value: $progress, in: 0...duration)
        .tint(.white)

      HStack {
        Text("0:\(Int(progress))")
        Spacer()
        Text("-0:\(Int(duration - progress))")
      }
      .font(.dynamicPretend(type: .medium, size: 13))
      .foregroundColor(.white)
    }
    .padding(.horizontal)
  }

  /// 재생 컨트롤 뷰
  private var controlView: some View {
    HStack(spacing: 40) {
      Button {
        print("backwardPlay")
      } label: {
        Image(.backwardPlay)
          .resizable()
          .aspectRatio(contentMode: .fit)
          .frame(width: 26.7, height: 23.94)
      }

      Button {
        isPlaying.toggle()
      } label: {
        Image(isPlaying ? .pausePlay : .startPlay)
          .resizable()
          .aspectRatio(contentMode: .fit)
          .frame(width: 44, height: 44)
      }

      Button {
        print("forwardPlay")
      } label: {
        Image(.forwardPlay)
          .resizable()
          .aspectRatio(contentMode: .fit)
          .frame(width: 26.7, height: 23.94)
      }
    }
    .foregroundColor(.white)
    .padding(.bottom, 35)
  }
}

#Preview {
  CheerSongView()
}
