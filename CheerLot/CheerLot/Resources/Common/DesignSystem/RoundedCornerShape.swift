//
//  RoundedCornerShape.swift
//  CheerLot
//
//  Created by 이현주 on 5/31/25.
//

import SwiftUI

public struct RoundedCornerShape: Shape {
  public var radius: CGFloat = .infinity
  public var corners: UIRectCorner = .allCorners

  public init(radius: CGFloat, corners: UIRectCorner) {
    self.radius = radius
    self.corners = corners
  }

  public func path(in rect: CGRect) -> Path {
    let path = UIBezierPath(
      roundedRect: rect,
      byRoundingCorners: corners,
      cornerRadii: CGSize(width: radius, height: radius)
    )
    return Path(path.cgPath)
  }
}

// MARK: - 특정 corner에 raidus 적용하는 Shape
//RoundedCornerShape(
//  radius: 10, corners: [.bottomLeft, .bottomRight]
//)
//    .fill(...
//    .frame(...
// corners 파라미터에 radius 적용 원하는 corner 위치 넣기
