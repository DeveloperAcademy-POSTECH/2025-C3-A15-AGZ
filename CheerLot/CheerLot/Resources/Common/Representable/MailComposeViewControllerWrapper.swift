//
//  MailComposeViewControllerWrapper.swift
//  CheerLot
//
//  Created by 이현주 on 7/9/25.
//

import SwiftUI
import MessageUI

struct MailComposeViewControllerWrapper: UIViewControllerRepresentable {
    @Binding var result: Result<MFMailComposeResult, Error>?
    @Binding var showAlert: Bool
//    @Binding var showEmailAlert: Bool
    @Binding var alertTitle: String
    @Binding var alertMessage: String
    
    private let recipient: String = "cheerlot.business@gmail.com"
    private let subject: String = "[버그신고] 쳐랏 앱 오류 제보"
    private let bodyString: String = """
                                     1. 앱 버전 : \(Constants.appVersion)
                                     2. 사용 기기 : \(UIDevice.current.modelName)
                                     3. OS 버전 : \(UIDevice.current.systemVersion)
                                     ================================
                                     ■ 발생 일시 :
                                     ■ 발생 화면/기능 :
                                     ■ 상세내용 :
                                     ■ 첨부 스크린샷 (선택 / 스크린샷 첨부 시 빠른 응답이 가능합니다!)
                                     """
    
    @Environment(\.presentationMode) var presentationMode
    
    func makeUIViewController(context: Context) -> UIViewController {
        if MFMailComposeViewController.canSendMail() {
            let mailComposer = MFMailComposeViewController()
            mailComposer.setToRecipients([recipient])
            mailComposer.setSubject(subject)
            mailComposer.setMessageBody(bodyString, isHTML: false)
            mailComposer.mailComposeDelegate = context.coordinator
            return mailComposer
        } else {
            DispatchQueue.main.async {
                openMailAppFallback()
                presentationMode.wrappedValue.dismiss()
            }
            return UIViewController()
        }
    }
    
    private func openMailAppFallback() {
        let encodedSubject = subject.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let encodedBody = bodyString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let urlString = "mailto:cheerlot.business@gmail.com?subject=\(encodedSubject)&body=\(encodedBody)"
        
        if let emailURL = URL(string: urlString),
           UIApplication.shared.canOpenURL(emailURL) {
            UIApplication.shared.open(emailURL)
        }
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) { }
    
    func handleMailResult(_ result: MFMailComposeResult) {
        switch result {
        case .cancelled:
            showAlertWithMessage("메일 작성을 취소하였습니다.\n도움이 필요하실 때 다시 문의해 주세요.", title: "메일 취소 완료")
        case .saved:
            showAlertWithMessage("메일이 저장되었습니다", title: "메일 저장 완료")
        case .sent:
            showAlertWithMessage("문의해주셔서 감사합니다.\n빠른 확인 후 답변드리겠습니다.", title: "메일 전송 완료")
        case .failed:
            showAlertWithMessage("메일 전송에 실패하였습니다", title: "메일 전송 실패")
        @unknown default:
            showAlertWithMessage("문제가 발생했습니다. 잠시 후 다시 시도해주세요", title: "전송 오류")
        }
    }
    
    func handleMailError(_ error: Error) {
        showAlertWithMessage("Error: \(error.localizedDescription)", title: "오류")
    }
    
    func showAlertWithMessage(_ message: String, title: String) {
        alertTitle = title
        alertMessage = message
        showAlert = true
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }
    
    class Coordinator: NSObject, MFMailComposeViewControllerDelegate {
        var parent: MailComposeViewControllerWrapper
        
        init(parent: MailComposeViewControllerWrapper) {
            self.parent = parent
        }
        
        func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
            if let error = error {
                parent.handleMailError(error)
            } else {
                parent.handleMailResult(result)
            }
            controller.dismiss(animated: true)
        }
    }
}
