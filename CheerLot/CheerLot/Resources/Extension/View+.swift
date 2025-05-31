//
//  View+.swift
//  CheerLot
//
//  Created by 이현주 on 5/31/25.
//

import SwiftUI

extension View {
    //특정 corner radius 적용 함수
    public func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}
