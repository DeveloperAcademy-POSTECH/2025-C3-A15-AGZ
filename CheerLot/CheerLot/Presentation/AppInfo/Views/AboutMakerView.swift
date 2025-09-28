//
//  AboutMakerView.swift
//  CheerLot
//
//  Created by 이현주 on 7/6/25.
//

import SwiftUI

struct AboutMakerView: View {
  var screenName: String = LoggerEvent.View.aboutMakerV

  @EnvironmentObject var container: DIContainer

  var body: some View {
    VStack(spacing: DynamicLayout.dynamicValuebyHeight(10)) {

      Image(.aboutMakers)
        .frame(maxWidth: .infinity)
        .scaledToFit()
        .padding(.horizontal, DynamicLayout.dynamicValuebyWidth(16))

      bottomMenuView
        .padding(.horizontal, DynamicLayout.dynamicValuebyWidth(21))
    }
    .navigationBarBackButtonHidden(true)
    .customNavigation(
      title: "만든 사람들",
      leadingAction: {
        container.navigationRouter.pop()
      }
    )
    .onAppear {
      AnalyticsLogger.logScreen(screenName)
    }
  }

  private var bottomMenuView: some View {
    VStack(spacing: DynamicLayout.dynamicValuebyHeight(16)) {

      RoundedRectangle(cornerRadius: 1)
        .strokeBorder(
          style: StrokeStyle(lineWidth: 1, dash: [DynamicLayout.dynamicValuebyWidth(9)])
        )
        .foregroundStyle(Color.gray02)
        .frame(height: 1)

      List {
        ForEach(AboutMakerInfo.allCases) { menu in
          AppInfoMenuCell(title: menu.rawValue)
            .contentShape(Rectangle())
            .onTapGesture {
              AnalyticsLogger.logCellClick(
                screen: screenName, cell: LoggerEvent.CellEvent.appInfoMenuCellTapped,
                index: menu.id)
              if let url = URL(string: menu.url) {
                UIApplication.shared.open(url)
              }
            }
        }
        .listRowSeparator(.hidden)
        .listRowInsets(EdgeInsets())
      }
      .listStyle(.plain)
      .scrollDisabled(true)
    }
  }
}

#Preview {
  AboutMakerView()
}
