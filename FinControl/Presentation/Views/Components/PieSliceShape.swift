//
//  PieSliceShape.swift
//  FinControl
//
//  Created by Camila Vincensi on 06/01/26.
//

import SwiftUI

struct PieSliceShape: Shape {

    let startAngle: Angle
    let endAngle: Angle

    func path(in rect: CGRect) -> Path {
        var path = Path()

        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) / 2

        path.move(to: center)
        path.addArc(
            center: center,
            radius: radius,
            startAngle: startAngle - .degrees(90),
            endAngle: endAngle - .degrees(90),
            clockwise: false
        )

        path.closeSubpath()
        return path
    }
}
