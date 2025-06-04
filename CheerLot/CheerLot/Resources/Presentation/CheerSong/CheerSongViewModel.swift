//
//  CheerSongViewModel.swift
//  CheerLot
//
//  Created by 이승진 on 6/1/25.
//

import AVFoundation
import Combine
import Foundation
import SwiftUI

@Observable
class CheerSongViewModel {

  // MARK: - Properties
  /// AVPlayer
  private var player: AVPlayer?
  private var timeObserverToken: Any?
  private var cancellables = Set<AnyCancellable>()

  /// 상태
  var isPlaying: Bool = false
  var progress: Double = 0.0
  var duration: Double = 1.0

  var title: String = ""
  var lyricsLines: String = ""
  var playerName: String = ""

  /// 전체 재생 목록
  private var playlist: [CheerSongItem] = []

  /// 현재 재생 중인 곡 인덱스
  var currentIndex: Int = 0

  /// 자동 다음 곡 재생 콜백
  var onSongDidFinish: (() -> Void)?

  // MARK: - Init

  init() {}

  deinit {
    removeTimeObserver()
  }

  // MARK: - Function

  /// 플레이리스트 구성
  func configurePlaylist(with players: [Player], startAt index: Int = 0) {
    self.playlist = players.flatMap { player in
      (player.cheerSongList ?? []).map { CheerSongItem(player: player, song: $0) }
    }

    print("🧾 구성된 playlist 개수: \(playlist.count)")
    for (i, item) in playlist.enumerated() {
      print(" - \(i): \(item.player.name) / \(item.song.title)")
    }

    self.currentIndex = index
    loadCurrent()
  }

  /// 곡 재생 컨트롤
  private func loadCurrent() {
    guard playlist.indices.contains(currentIndex) else { return }
    let item = playlist[currentIndex]

    self.playerName = item.player.name
    self.title = item.song.title
    self.lyricsLines = item.song.lyrics

    removeTimeObserver()
    NotificationCenter.default.removeObserver(
      self, name: .AVPlayerItemDidPlayToEndTime, object: nil)
    player?.pause()
    player?.replaceCurrentItem(with: nil)
    player = nil
    isPlaying = false
    progress = 0.0
    duration = 1.0

    playerName = item.player.name
    title = item.song.title
    lyricsLines = item.song.lyrics

    loadSong(from: item.song.audioFileName)
  }

  /// 다음곡
  func playNext() {
    if currentIndex + 1 < playlist.count {
      currentIndex += 1
    } else {
      currentIndex = 0
    }

    loadCurrent()
  }

  /// 이전곡
  func playPrevious() {
    if currentIndex > 0 {
      currentIndex -= 1
    } else {
      currentIndex = playlist.count - 1
    }

    loadCurrent()
  }

  /// 음악 로딩
  private func loadSong(from fileName: String) {
    guard let url = Bundle.main.url(forResource: fileName, withExtension: nil) else {
      print("❌ 로컬 파일 \(fileName) 찾을 수 없음")
      return
    }

    let playerItem = AVPlayerItem(url: url)
    player = AVPlayer(playerItem: playerItem)

    observeProgress()
    observeDuration()
    player?.play()
    isPlaying = true

    NotificationCenter.default.addObserver(
      self,
      selector: #selector(songDidFinish),
      name: .AVPlayerItemDidPlayToEndTime,
      object: playerItem
    )
  }

  /// 자동 다음 곡 처리
  @objc private func songDidFinish() {
    onSongDidFinish?()
  }

  /// 재생 제어
  func togglePlayback() {
    guard let player else { return }

    if isPlaying {
      player.pause()
    } else {
      player.play()
    }

    isPlaying.toggle()
  }

  /// 슬라이드 옮겼을 때 지정한 위치로 이동
  func seek(to time: Double) {
    let cmTime = CMTime(seconds: time, preferredTimescale: 600)
    player?.seek(to: cmTime)
  }

  /// 뷰 사라질 때 호출
  func cleanup() {
    removeTimeObserver()
    NotificationCenter.default.removeObserver(
      self, name: .AVPlayerItemDidPlayToEndTime, object: nil)
    player?.pause()
    player?.replaceCurrentItem(with: nil)
    player = nil
    isPlaying = false
  }

  // MARK: - Observers
  /// progress  업데이트
  private func observeProgress() {
    guard let player else { return }

    // 0.1초마다 현재 시간 추적
    let interval = CMTime(seconds: 0.1, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
    timeObserverToken = player.addPeriodicTimeObserver(forInterval: interval, queue: .main) {
      [weak self] time in
      guard let self = self,
        let duration = player.currentItem?.duration.seconds,
        duration.isFinite
      else { return }
      self.duration = duration
      self.progress = time.seconds
    }
  }

  /// duration 반영하는 함수
  private func observeDuration() {
    player?.currentItem?.publisher(for: \.duration)
      .compactMap { $0.seconds }
      .filter { $0 > 0 }
      .sink { [weak self] duration in
        self?.duration = duration
      }
      .store(in: &cancellables)
  }

  private func removeTimeObserver() {
    if let token = timeObserverToken {
      player?.removeTimeObserver(token)
      timeObserverToken = nil
    }
  }
}

/// 타임 포매터
extension TimeInterval {
  var asTimeString: String {
    let minutes = Int(self) / 60
    let seconds = Int(self) % 60
    return String(format: "%02d:%02d", minutes, seconds)
  }
}
