//
//  MainAppInfoView.swift
//  CheerLot
//
//  Created by 이현주 on 7/6/25.
//

import MessageUI
import SwiftUI

struct MainAppInfoView: View {

  @EnvironmentObject var container: DIContainer
  @State private var showTeamSelectSheet = false
  @State var showSafari = false

  var screenName: String = LoggerEvent.View.appInfoMainV

  var body: some View {
    VStack(spacing: DynamicLayout.dynamicValuebyHeight(15)) {

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
    //    .ignoresSafeArea(edges: .top)
    .navigationBarBackButtonHidden(true)
    .customNavigation(
      title: "앱 정보",
      leadingAction: {
        container.navigationRouter.pop()
      }
    )
    .sheet(isPresented: $showTeamSelectSheet) {
      TeamSelectSheetView()
        .presentationDetents([.height(DynamicLayout.dynamicValuebyHeight(700))])
    }
    .onAppear {
      AnalyticsLogger.logScreen(screenName)
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
        AnalyticsLogger.logButtonClick(
          screen: screenName, button: LoggerEvent.ButtonEvent.editTeamBtnTapped)
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
              AnalyticsLogger.logCellClick(
                screen: screenName, cell: LoggerEvent.CellEvent.appInfoMenuCellTapped,
                index: menu.id)
              //              if menu == .reportBug {
              //                self.showSafari = true
              //              } else {
              //                router.push(menu.route!)
              //              }
              if menu == .reportBug {
                showSafari = true
              } else if let route = menu.route {
                container.navigationRouter.push(route)
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
