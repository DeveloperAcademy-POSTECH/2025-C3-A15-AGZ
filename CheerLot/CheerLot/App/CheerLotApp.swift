//
//  CheerLotApp.swift
//  CheerLot
//
//  Created by 이현주 on 5/29/25.
//

import AdSupport
import AppTrackingTransparency
import FirebaseAnalytics
import FirebaseCore
import SwiftData
import SwiftUI

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
  ) -> Bool {
    FirebaseApp.configure()
    if let uuid = UIDevice.current.identifierForVendor?.uuidString {
      Analytics.setUserID(uuid)
    }

    // 앱 추적 권한 요청
    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
      if #available(iOS 14, *) {
        ATTrackingManager.requestTrackingAuthorization { status in
          switch status {
          case .authorized:  // 허용됨
            print("Authorized")
            print("IDFA = \(ASIdentifierManager.shared().advertisingIdentifier)")
            Analytics.setAnalyticsCollectionEnabled(true)
          case .denied:  // 거부됨
            print("Denied")
            Analytics.setAnalyticsCollectionEnabled(false)
          case .notDetermined:  // 결정되지 않음
            print("Not Determined")
            Analytics.setAnalyticsCollectionEnabled(false)
          case .restricted:  // 제한됨
            print("Restricted")
            Analytics.setAnalyticsCollectionEnabled(false)
          @unknown default:  // 알려지지 않음
            print("Unknow")
            Analytics.setAnalyticsCollectionEnabled(false)
          }
        }
      }
    }
    return true
  }
}

@main
struct CheerLotApp: App {

  let modelContainer: ModelContainer

  @StateObject private var themeManager = ThemeManager()

  @StateObject private var remoteConfigChecker = RemoteConfigChecker()

  /// 앱 흐름 상태 뷰모델
  @StateObject var appFlowViewModel: AppFlowViewModel = .init()

  /// DI Container
  @StateObject var container: DIContainer = .init()

  init() {
    do {
      modelContainer = try ModelContainer(
        for: Team.self, Player.self, CheerSong.self, migrationPlan: CheerLotMigrationPlan.self)
      DataMigrationService.migrateDataIfNeeded(modelContext: modelContainer.mainContext)

      let currentTheme = ThemeManager.shared.currentTheme
      UIApplication.shared.setAlternateIconName(AppIcon.from(theme: currentTheme).iconName) {
        error in
        if let error = error {
          print("앱 아이콘 설정 실패: \(error.localizedDescription)")
        }
      }
    } catch {
      fatalError("Failed to create ModelContainer: \(error)")
    }
  }

  @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

  var body: some Scene {
    WindowGroup {
      switch appFlowViewModel.appState {
      case .splash:
        SplashView()
          .environmentObject(appFlowViewModel)  // 상태 전환 위해 주입
      case .main:
        NavigationRoutingView()
      }
    }
    .environmentObject(themeManager)
    .environmentObject(remoteConfigChecker)
    .environmentObject(container)
    .modelContainer(modelContainer)
  }
}
