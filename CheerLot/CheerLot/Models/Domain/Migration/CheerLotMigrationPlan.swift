//
//  CheerLotMigrationPlan.swift
//  CheerLot
//
//  Created by 이현주 on 9/28/25.
//

import Foundation
import SwiftData

enum CheerLotMigrationPlan: SchemaMigrationPlan {
  static var schemas: [any VersionedSchema.Type] {
    [CheerLotSchemaV1.self, CheerLotSchemaV2.self]
  }

  static var stages: [MigrationStage] {
    [migrateV1toV2]
  }

  static let migrateV1toV2 =
    MigrationStage
    .custom(
      fromVersion: CheerLotSchemaV1.self,
      toVersion: CheerLotSchemaV2.self,
      willMigrate: { context in
        // 이 시점에서는 V1 모델 기준으로 접근 가능
        // Player / CheerSong 모두 날려버리기
        let players = try context.fetch(FetchDescriptor<CheerLotSchemaV1.Player>())
        for player in players {
          context.delete(player)
        }
        let songs = try context.fetch(FetchDescriptor<CheerLotSchemaV1.CheerSong>())
        for song in songs {
          context.delete(song)
        }

        try context.save()
      },
      didMigrate: { context in
        // 이 시점에서는 V2 모델 기준
        // Team만 유지되고, 선수는 API를 통해 새로 불러와 저장
        let teams = try context.fetch(FetchDescriptor<CheerLotSchemaV2.Team>())
        for team in teams {
          team.lineupVersion = -1
          team.playersVersion = -1
          team.hasGame = true
          team.isSeasonActive = true
        }
        try context.save()
      }
    )
}
