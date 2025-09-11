//
//  CustomNavigationBar.swift
//  CheerLot
//
//  Created by 이승진 on 6/2/25.
//

import SwiftUI

/// 재사용 가능한 커스텀 툴바 Modifier
struct CustomNavigationModifier: ViewModifier {

  let title: String?
  let leadingAction: () -> Void
  let showDoneButton: Bool
  let trailingAction: (() -> Void)?
  let whiteStyle: Bool

  let bottomPadding: CGFloat = 22
  let topPadding: CGFloat = 11

  func body(content: Content) -> some View {
    let color: Color = whiteStyle ? .white : .black

    content
      .toolbar {
        // 왼쪽: 뒤로가기
        ToolbarItem(placement: .topBarLeading) {
          Button(action: leadingAction) {
            Image(systemName: "chevron.left")
              .fontWeight(.medium)
          }
          .tint(color)
          .padding(.bottom, bottomPadding)
          .padding(.top, topPadding)
        }

        // 가운데 타이틀
        if let title = title {
          ToolbarItem(placement: .principal) {
            Text(title)
              .font(.dynamicPretend(type: .bold, size: 20))
              .foregroundStyle(color)
              .padding(.bottom, bottomPadding)
              .padding(.top, topPadding)
          }
        }

        // 오른쪽 버튼
        if showDoneButton, let trailingAction {
          ToolbarItem(placement: .topBarTrailing) {
            Button("완료", action: trailingAction)
              .font(.dynamicPretend(type: .regular, size: 18))
              .foregroundStyle(color)
              .padding(.bottom, bottomPadding)
              .padding(.top, topPadding)
          }
        }
      }
  }
}

extension View {
  /// 커스텀 네비게이션 툴바를 뷰에 적용하는 Modifier
  ///
  /// - Parameters:
  ///   - title: 툴바 중앙 타이틀 (선택 사항)
  ///   - leadingAction: 뒤로가기 버튼을 눌렀을 때 실행할 액션
  ///   - trailingIcon: 오른쪽 버튼에 표시할 이미지 (선택 사항)
  ///   - trailingAction: 오른쪽 버튼 터치 시 실행될 액션 (선택 사항)
  func customNavigation(
    title: String? = nil,
    leadingAction: @escaping () -> Void,
    showDoneButton: Bool = false,
    trailingAction: (() -> Void)? = nil,
    whiteStyle: Bool = false
  ) -> some View {
    self.modifier(
      CustomNavigationModifier(
        title: title,
        leadingAction: leadingAction,
        showDoneButton: showDoneButton,
        trailingAction: trailingAction,
        whiteStyle: whiteStyle
      )
    )
  }
}
