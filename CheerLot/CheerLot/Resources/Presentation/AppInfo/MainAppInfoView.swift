//
//  MainAppInfoView.swift
//  CheerLot
//
//  Created by 이현주 on 7/6/25.
//

import SwiftUI
import MessageUI

struct MainAppInfoView: View {
    @EnvironmentObject var router: NavigationRouter
    @State private var showTeamSelectSheet = false
    
    // email 관련 변수
    @State private var result: Result<MFMailComposeResult, Error>? = nil
    @State private var alertMessage: String = ""
    @State private var alertTitle: String = ""
    @State private var isShowingMailView: Bool = false
    @State private var showAlert: Bool = false
//    @State private var showEmailAlert: Bool = false
    
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
                .lineHeightMultipleAdaptPretend(fontType: .medium, fontSize: 10, lineHeight: 1.3, letterSpacing: -0.04)
                .foregroundStyle(Color.gray03)
                .padding(.bottom, DynamicLayout.dynamicValuebyHeight(30))
        }
        .ignoresSafeArea(edges: .top)
        .sheet(isPresented: $showTeamSelectSheet) {
            TeamSelectSheetView()
                .presentationDetents([.height(DynamicLayout.dynamicValuebyHeight(700))])
        }
    }
    
    func makeTitleWithContents<Content: View>(
        title: String,
        @ViewBuilder content: () -> Content
    ) -> some View {
        VStack(alignment: .leading, spacing: DynamicLayout.dynamicValuebyHeight(8)) {
            Text(title)
                .lineHeightMultipleAdaptPretend(fontType: .semibold, fontSize: 20, lineHeight: 1.3, letterSpacing: -0.02)

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
                                self.isShowingMailView.toggle()
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
            .sheet(isPresented: $isShowingMailView) {
                MailComposeViewControllerWrapper(result: $result, showAlert: $showAlert, alertTitle: $alertTitle, alertMessage: $alertMessage)
            }
            .alert(isPresented: $showAlert) {
                Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text("확인")))
            }
//            .alert(isPresented: $showEmailAlert) {
//                Alert(
//                    title: Text(alertTitle),
//                    message: Text(alertMessage),
//                    primaryButton: .default(Text("설정으로 이동")) {
//                        if let settingsURL = URL(string: UIApplication.openSettingsURLString),
//                           UIApplication.shared.canOpenURL(settingsURL) {
//                            UIApplication.shared.open(settingsURL)
//                        }
//                    },
//                    secondaryButton: .cancel(Text("취소"))
//                )
//            }
        }
    }
}

#Preview {
    MainAppInfoView()
}
