//
//  CirclePhysicsShape.swift
//  Peggle
//
//  Created by Peter Jung on 2023/02/12.
//

import Foundation

struct CirclePhysicsShape: PhysicsShape {
    var radius: CGFloat

    var width: CGFloat {
        radius * 2
    }

    var height: CGFloat {
        radius * 2
    }

    init(radius: CGFloat = 1) {
        if radius > 0 {
            self.radius = radius
        } else {
            self.radius = 1
        }
    }

    mutating func scale(by value: CGFloat) {
        radius *= value
    }
}
