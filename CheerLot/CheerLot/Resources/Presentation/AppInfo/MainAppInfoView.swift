//
//  MainAppInfoView.swift
//  CheerLot
//
//  Created by 이현주 on 7/6/25.
//

import MessageUI
import SwiftUI

struct MainAppInfoView: View {
  @EnvironmentObject var router: NavigationRouter
  @State private var showTeamSelectSheet = false
  @State var showSafari = false

  var body: some View {
    VStack(spacing: DynamicLayout.dynamicValuebyHeight(15)) {
      CustomNavigationBar(
        showBackButton: true,
        title: { Text("앱 정보") },
        tintColor: .black
      )

      VStack(spacing: DynamicLayout.dynamicValuebyHeight(30)) {

        myTeamInfoView

        cheerLotInfoView
      }
      .padding(.horizontal, DynamicLayout.dynamicValuebyWidth(21))

      Spacer()

      // version Info
      Text("쳐랏 | App Version \(Constants.appVersion)")
        .lineHeightMultipleAdaptPretend(
          fontType: .medium, fontSize: 12, lineHeight: 1.3, letterSpacing: -0.04
        )
        .foregroundStyle(Color.gray03)
        .padding(.bottom, DynamicLayout.dynamicValuebyHeight(30))
    }
    .ignoresSafeArea(edges: .top)
    .sheet(isPresented: $showTeamSelectSheet) {
      TeamSelectSheetView()
        .presentationDetents([.height(DynamicLayout.dynamicValuebyHeight(700))])
    }
    .onAppear {
      AnalyticsLogger.logScreen(LoggerEvent.View.appInfoMainV)
    }
  }

  func makeTitleWithContents<Content: View>(
    title: String,
    @ViewBuilder content: () -> Content
  ) -> some View {
    VStack(alignment: .leading, spacing: DynamicLayout.dynamicValuebyHeight(8)) {
      Text(title)
        .lineHeightMultipleAdaptPretend(
          fontType: .semibold, fontSize: 20, lineHeight: 1.3, letterSpacing: -0.02)

      content()
    }
  }

  private var myTeamInfoView: some View {
    makeTitleWithContents(title: "나의 팀") {
      TeamEditButton {
        showTeamSelectSheet = true
      }
    }
  }

  private var cheerLotInfoView: some View {
    makeTitleWithContents(title: "쳐랏 정보") {
      List {
        ForEach(AppInfoMenu.allCases) { menu in
          AppInfoMenuCell(title: menu.rawValue)
            .contentShape(Rectangle())
            .onTapGesture {
              if menu == .reportBug {
                self.showSafari = true
              } else {
                router.push(menu.route!)
              }
            }
        }
        .listRowSeparator(.hidden)
        .listRowInsets(EdgeInsets())
      }
      .listStyle(.plain)
      .scrollDisabled(true)
      .sheet(isPresented: $showSafari) {
        SafariView(url: URL(string: Constants.InquiryURL)!)
      }
    }
  }
}

#Preview {
  MainAppInfoView()
}
