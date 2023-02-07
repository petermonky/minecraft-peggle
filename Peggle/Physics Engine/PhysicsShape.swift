//
//  PhysicsShape.swift
//  Peggle
//
//  Created by Peter Jung on 2023/02/06.
//

import Foundation

protocol PhysicsShape: Equatable {
    var center: CGPoint { get }
}

struct CirclePhysicsShape: PhysicsShape {
    var center: CGPoint
    var radius: CGFloat

    init(radius: CGFloat = 0) {
        self.center = CGPoint.zero
        self.radius = radius
    }
}
