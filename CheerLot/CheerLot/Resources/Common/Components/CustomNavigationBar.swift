//
//  CustomNavigationBar.swift
//  CheerLot
//
//  Created by 이승진 on 6/2/25.
//

import SwiftUI
import UIKit

struct CustomNavigationBar<Title: View, Leading: View, Trailing: View>: View {
  private let title: Title
  private let leading: Leading
  private let trailing: Trailing

  init(
    @ViewBuilder title: () -> Title = { EmptyView() },
    @ViewBuilder leading: () -> Leading = { EmptyView() },
    @ViewBuilder trailing: () -> Trailing = { EmptyView() }
  ) {
    self.title = title()
    self.leading = leading()
    self.trailing = trailing()
  }

  var body: some View {
    ZStack {
      HStack {
        leading
          .frame(width: 44, height: 44)
          .font(.dynamicPretend(type: .medium, size: 20))
        Spacer()
        trailing
          .frame(width: 44, height: 44)
          .font(.dynamicPretend(type: .regular, size: 18))
      }
      .padding(.horizontal, DynamicLayout.dynamicValuebyWidth(21))

      title
        .font(.dynamicPretend(type: .bold, size: 20))
        .multilineTextAlignment(.center)
        .frame(maxWidth: .infinity)
        .accessibilityAddTraits(.isHeader)
    }
    .foregroundStyle(.white)
    .padding(.top, topSafeAreaInset)
  }

  private var topSafeAreaInset: CGFloat {
    UIApplication.shared.connectedScenes
      .compactMap { ($0 as? UIWindowScene)?.windows.first?.safeAreaInsets.top }
      .first ?? 0
  }
}

// MARK: - 뒤로가기 스와이프
extension UINavigationController: @retroactive UIGestureRecognizerDelegate {
  open override func viewDidLoad() {
    super.viewDidLoad()
    interactivePopGestureRecognizer?.delegate = self
  }

  public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
    return viewControllers.count > 1
  }
}

#Preview {
  ZStack {
    Color.black
    CustomNavigationBar(
      title: { Text("선수 교체") },

      leading: {
        Button {
        } label: {
          Image(systemName: "chevron.left")
        }
      },

      trailing: {
        Button {
        } label: {
          Text("완료")
        }
      }
    )
  }
  .ignoresSafeArea()
}
