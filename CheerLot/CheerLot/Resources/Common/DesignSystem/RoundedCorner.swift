//
//  RoundedCorner.swift
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
