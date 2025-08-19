//
//  SafariView.swift
//  CheerLot
//
//  Created by 이현주 on 7/9/25.
//

import SafariServices
import SwiftUI

// MARK: 컴포넌트나 다른 곳으로 이사가자 -루미-
struct SafariView: UIViewControllerRepresentable {

  let url: URL

  func makeUIViewController(context: UIViewControllerRepresentableContext<SafariView>)
    -> SFSafariViewController
  {
    return SFSafariViewController(url: url)
  }

  func updateUIViewController(
    _ uiViewController: SFSafariViewController,
    context: UIViewControllerRepresentableContext<SafariView>
  ) {

  }

}
