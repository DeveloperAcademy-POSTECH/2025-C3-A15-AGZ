//
//  AppInfoTextPageView.swift
//  CheerLot
//
//  Created by 이현주 on 7/8/25.
//

import SwiftUI

struct AppInfoTextPageView: View {
  let title: String
  let text: String

  @EnvironmentObject var container: DIContainer

  var body: some View {
    VStack(spacing: DynamicLayout.dynamicValuebyHeight(15)) {
      ScrollView {
        Text(text)
          .lineHeightMultipleAdaptPretend(
            fontType: .regular,
            fontSize: 16,
            lineHeight: 1.5,
            letterSpacing: -0.05
          )
          .padding(.horizontal, DynamicLayout.dynamicValuebyWidth(24))
      }
    }
    .navigationBarBackButtonHidden(true)
    .customNavigation(
      title: "\(title)",
      leadingAction: {
        container.navigationRouter.pop()
      }
    )
    .onAppear {
      AnalyticsLogger.logScreen(LoggerEvent.View.termsV)
    }
  }
}
