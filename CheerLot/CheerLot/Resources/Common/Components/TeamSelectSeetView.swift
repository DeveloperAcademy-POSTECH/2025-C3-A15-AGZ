//
//  TeamSelectSeetView.swift
//  CheerLot
//
//  Created by 이승진 on 6/10/25.
//

import SwiftUI

struct TeamSelectSeetView: View {
  @Binding var selectedTheme: Theme?

  let columns = [
    GridItem(.flexible(), spacing: 15),
    GridItem(.flexible(), spacing: 15),
  ]

  var body: some View {
    VStack(spacing: 26) {
      ZStack {
        Capsule()
          .fill(.gray03)
          .frame(width: 48, height: 4)

        CustomNavigationBar(
          title: {
            Text("응원팀 변경")
              .font(.dynamicPretend(type: .bold, size: 20))
              .foregroundStyle(.black)
          },
          trailing: {
            Button {

            } label: {
              Text("완료")
                .font(.dynamicPretend(type: .regular, size: 18))
                .foregroundStyle(.blue)
            }
          }
        )
      }

      LazyVGrid(columns: columns, spacing: 9) {
        ForEach(Theme.allCases) { theme in
          TeamCard(theme: theme, isSelected: selectedTheme == theme)
            .onTapGesture {
              selectedTheme = theme
            }
        }
      }
      .padding(.horizontal, 31)
    }
  }
}
//
//#Preview {
//    TeamSelectSeetView()
//}
