//
//  CirclePhysicsShape.swift
//  Peggle
//
//  Created by Peter Jung on 2023/02/12.
//

import Foundation

struct CirclePhysicsShape: PhysicsShape {
    var radius: CGFloat

    init(radius: CGFloat = 1) {
        if radius > 0 {
            self.radius = radius
        } else {
            self.radius = 1
        }
    }
}
