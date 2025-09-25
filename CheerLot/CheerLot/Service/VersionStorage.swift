//
//  VersionStorage.swift
//  CheerLot
//
//  Created by 이현주 on 9/24/25.
//

import SwiftUI

/// AppStorage를 통해 API 버전을 관리하는 스토리지
final class VersionStorage: ObservableObject {
    @AppStorage(VersionStorageKeys.lineup) var storedLineupVersion: Int = -1
    @AppStorage(VersionStorageKeys.players) var storedPlayersVersion: Int = -1
}
