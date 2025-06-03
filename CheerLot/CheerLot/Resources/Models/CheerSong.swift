//
//  CheerSong.swift
//  CheerLot
//
//  Created by 이현주 on 5/30/25.
//

import SwiftData
import SwiftUI

@Model
class CheerSong: Hashable {
  var title: String
  var lyrics: String
  var audioFileName: String  // 로컬에 저장된 음원 파일 자체 이름 (확장자까지)

  init(title: String, lyrics: String, audioFileName: String) {
    self.title = title
    self.lyrics = lyrics
    self.audioFileName = audioFileName
  }
}
