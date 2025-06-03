//
//  DataMigrationService.swift
//  CheerLot
//
//  Created by theo on 6/2/25.
//

import Foundation
import SwiftData

class DataMigrationService {
  static func migrateDataIfNeeded(modelContext: ModelContext) {
    // 이미 마이그레이션 했는지 체크
    let migrationKey = "initialDataMigrated"
    if UserDefaults.standard.bool(forKey: migrationKey) {
      return
    }

    // JSON 파일 로드
    guard let url = Bundle.main.url(forResource: "teams", withExtension: "json"),
      let data = try? Data(contentsOf: url)
    else {
      print("Failed to load teams.json")
      return
    }

    do {
      let decoder = JSONDecoder()
      let teamsData = try decoder.decode(TeamsData.self, from: data)

      // 팀 데이터 저장
      for teamData in teamsData.teams {
        let team = Team(
          themeRaw: teamData.teamCode.lowercased(),
          teamMemeberList: [],
          lastUpdated: teamData.lastUpdated,
          lastOpponent: teamData.lastOpponent
        )

        // 선수 데이터 저장
        for playerData in teamData.players {
          // 응원가 생성
          let cheerSongs = playerData.cheerSongs.map { songData in
            CheerSong(
              title: songData.title,
              lyrics: songData.lyrics,
              audioFileName: songData.audioFileName
            )
          }

          // 선수 생성
          let player = Player(
            cheerSongList: cheerSongs,
            id: playerData.id,
            name: playerData.name,
            position: playerData.position ?? "",
            battingOrder: playerData.battingOrder
          )

          team.teamMemeberList?.append(player)
        }

        modelContext.insert(team)
      }

      // 마이그레이션 완료 표시
      try modelContext.save()
      UserDefaults.standard.set(true, forKey: migrationKey)

      print("Initial data migration completed successfully")
    } catch {
      print("Failed to migrate initial data: \(error)")
    }
  }
}
