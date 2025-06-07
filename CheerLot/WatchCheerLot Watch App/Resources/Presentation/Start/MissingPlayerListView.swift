import SwiftUI

struct MissingPlayerListView: View {
  var body: some View {
    ZStack {
      Color.black
        .ignoresSafeArea()

      Rectangle()
        .fill(
          RadialGradient(
            gradient: Gradient(colors: [
              Color(red: 0 / 255, green: 145 / 255, blue: 223 / 255).opacity(0.4),
              Color.clear,
            ]),
            center: UnitPoint(x: 0.90, y: 0.35),
            startRadius: WatchDynamicLayout.superWidth * 0.02,
            endRadius: WatchDynamicLayout.superWidth * 0.6
          )
        )
        .ignoresSafeArea()

      Rectangle()
        .fill(
          RadialGradient(
            gradient: Gradient(colors: [
              Color(red: 158 / 255, green: 149 / 255, blue: 255 / 255).opacity(0.4),
              Color.clear,
            ]),
            center: UnitPoint(x: 0.10, y: 0.95),
            startRadius: WatchDynamicLayout.superWidth * 0.02,
            endRadius: WatchDynamicLayout.superWidth * 0.6
          )
        )
        .ignoresSafeArea()

      VStack(spacing: WatchDynamicLayout.dynamicValuebyWidth(8)) {
        Text("최신 선수 명단이 없어요")
          .font(.dynamicPretend(type: .bold, size: WatchDynamicLayout.dynamicValuebyWidth(15)))
          .foregroundColor(.white)
          .multilineTextAlignment(.center)

        Text("iPhone에서 앱을 실행해주세요")
          .font(.dynamicPretend(type: .medium, size: WatchDynamicLayout.dynamicValuebyWidth(12)))
          .foregroundColor(Color(red: 177 / 255, green: 177 / 255, blue: 177 / 255))
          .multilineTextAlignment(.center)
      }
    }
  }
}

struct MissingPlayerListView_Previews: PreviewProvider {
  static var previews: some View {
    MissingPlayerListView()
  }
}
