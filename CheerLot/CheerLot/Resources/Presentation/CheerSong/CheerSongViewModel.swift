//
//  CheerSongViewModel.swift
//  CheerLot
//
//  Created by 이승진 on 6/1/25.
//

import Foundation
import AVFoundation
import SwiftUI
import Combine

struct CheerSongItem: Hashable {
  let player: Player
  let song: CheerSong
}

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
    var duration: Double = 1.0  // 기본값 1초 (0으로 두면 Slider in: 0...0 오류)
    
    var title: String = ""
    var lyricsLines: String = ""
    var playerName: String = ""
    
    /// 트랙전환
//    private var cheerSongs: [CheerSong] = []
    private var playlist: [CheerSongItem] = []
    
    /// 현재 곡
    var currentIndex: Int = 0
    
    /// 자동 재생 시 호출될 콜백
    var onSongDidFinish: (() -> Void)?
    
    // MARK: - Init
    
    init() {}
    
    deinit {
        removeTimeObserver()
    }
    
    // MARK: - Function
    
    /// 초기화 - Player 연결
    //    func configure(with cheerSong: CheerSong) {
    //        self.title = cheerSong.title
    //        self.lyricsLines = cheerSong.lyrics
    //        loadSong(from: cheerSong.audioFileName)
    //      }
//    func configure(with player: Player) {
//        self.playerName = player.name
//        self.cheerSongs = player.cheerSongList ?? []
//        self.currentIndex = 0
//        loadCurrentSong()
//    }
    func configurePlaylist(with players: [Player], startAt index: Int = 0) {
//        self.playlist = players.flatMap { player in
//          (player.cheerSongList ?? []).map { CheerSongItem(player: player, song: $0) }
//        }
//        self.currentIndex = index
//        loadCurrent()
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
    
//    private func loadCurrentSong() {
//        guard cheerSongs.indices.contains(currentIndex) else { return }
//        let song = cheerSongs[currentIndex]
//        title = song.title
//        lyricsLines = song.lyrics
//        loadSong(from: song.audioFileName)
//        observeSongEnd()
//    }
    private func loadCurrent() {
      guard playlist.indices.contains(currentIndex) else { return }
      let item = playlist[currentIndex]

      self.playerName = item.player.name
      self.title = item.song.title
      self.lyricsLines = item.song.lyrics

//      loadSong(from: item.song.audioFileName)

        removeTimeObserver()
//            player?.pause()
//            player = nil
        NotificationCenter.default.removeObserver(self, name: .AVPlayerItemDidPlayToEndTime, object: nil)
        player?.pause()
            player?.replaceCurrentItem(with: nil) // ✅ 기존 아이템 분리
            player = nil
            isPlaying = false
            progress = 0.0
            duration = 1.0

            playerName = item.player.name
            title = item.song.title
            lyricsLines = item.song.lyrics
         
         loadSong(from: item.song.audioFileName)

        
    }
    
    /// 다음곡으로 이동
//    func playNext() {
//        guard currentIndex + 1 < cheerSongs.count else { return }
//        currentIndex += 1
//        loadCurrentSong()
//    }
//    
//    /// 이전곡으로 이동
//    func playPrevious() {
//        guard currentIndex > 0 else { return }
//        currentIndex -= 1
//        loadCurrentSong()
//    }
    @MainActor
//    func playNext() {
//        guard currentIndex + 1 < playlist.count else { return }
//        currentIndex += 1
//        loadCurrent()
//        print("▶️ 현재 인덱스: \(currentIndex), 총 트랙 수: \(playlist.count)")
//      }
    func playNext() {
        print("🟠 playNext() 호출됨")

        guard currentIndex + 1 < playlist.count else {
            print("🔴 마지막 곡이라 다음 곡 없음")
            return
        }
        currentIndex += 1
        print("🟢 다음 곡으로 이동: \(currentIndex) / \(playlist.count)")
        loadCurrent()
    }

    @MainActor
      func playPrevious() {
        guard currentIndex > 0 else { return }
        currentIndex -= 1
        loadCurrent()
          print("▶️ 현재 인덱스: \(currentIndex), 총 트랙 수: \(playlist.count)")
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
    
    func seek(to time: Double) {
        let cmTime = CMTime(seconds: time, preferredTimescale: 600)
        player?.seek(to: cmTime)
    }
    
    func cleanup() {
        removeTimeObserver()
        NotificationCenter.default.removeObserver(self, name: .AVPlayerItemDidPlayToEndTime, object: nil)
        player?.pause()
        player?.replaceCurrentItem(with: nil)
        player = nil
        isPlaying = false
    }
    
    // MARK: - Observers
    
    private func observeProgress() {
        guard let player else { return }
        
        // 0.1초마다 현재 시간 추적
        let interval = CMTime(seconds: 0.1, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        timeObserverToken = player.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self] time in
            guard let self = self,
                  let duration = player.currentItem?.duration.seconds,
                  duration.isFinite else { return }
            self.duration = duration
            self.progress = time.seconds
        }
    }
    
    private func observeDuration() {
        player?.currentItem?.publisher(for: \.duration)
            .compactMap { $0.seconds }
            .filter { $0 > 0 }
            .sink { [weak self] duration in
                self?.duration = duration
            }
            .store(in: &cancellables)
    }
    
//    private func observeSongEnd() {
//        NotificationCenter.default.addObserver(
//            forName: .AVPlayerItemDidPlayToEndTime,
//            object: nil,
//            queue: .main
//        ) { [weak self] _ in
//            self?.onSongDidFinish?()
//        }
//    }
    
    private func removeTimeObserver() {
        if let token = timeObserverToken {
            player?.removeTimeObserver(token)
            timeObserverToken = nil
        }
    }
}

extension TimeInterval {
    var asTimeString: String {
        let minutes = Int(self) / 60
        let seconds = Int(self) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}
