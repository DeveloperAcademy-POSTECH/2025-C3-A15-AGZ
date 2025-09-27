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

    // 앱에서 지원하는 팀 코드들 정의
    let teamCodes = [
      "OB", "HH", "HT", "WO", "KT", "LG", "LT", "NC", "SS", "SK",
    ]

    // SwiftData에 팀 저장
    for code in teamCodes {
      let team = Team(
        themeRaw: code.lowercased(),
        teamMemeberList: [],
        lastUpdated: "",  // 초기값 (서버 API로 갱신 예정)
        lastOpponent: ""  // 초기값 (서버 API로 갱신 예정)
      )
      modelContext.insert(team)
    }

    // 마이그레이션 완료 표시
    do {
      try modelContext.save()
      UserDefaults.standard.set(true, forKey: migrationKey)

      print("Initial data migration completed successfully")
    } catch {
      print("Failed to migrate initial data: \(error)")
    }
  }
}
