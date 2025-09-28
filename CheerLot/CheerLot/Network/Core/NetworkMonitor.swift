//
//  NetworkMonitor.swift
//  CheerLot
//
//  Created by 이승진 on 7/7/25.
//

import Network
import SwiftUI

@Observable
class NetworkMonitor {
  private let monitor = NWPathMonitor()
  private let queue = DispatchQueue(label: "NetworkMonitor")

  var isConnected: Bool = true

  init() {
    monitor.pathUpdateHandler = { [weak self] path in
      DispatchQueue.main.async {
        self?.isConnected = (path.status == .satisfied)
      }
    }
    monitor.start(queue: queue)
  }

  deinit {
    monitor.cancel()
  }
}
