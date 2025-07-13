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

  var body: some View {
    VStack(spacing: DynamicLayout.dynamicValuebyHeight(15)) {
      CustomNavigationBar(
        showBackButton: true,
        title: { Text(title) },
        tintColor: .black
      )

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
    .ignoresSafeArea(edges: .top)
    .onAppear {
      AnalyticsLogger.logScreen(LoggerEvent.View.termsV)
    }
  }
}
