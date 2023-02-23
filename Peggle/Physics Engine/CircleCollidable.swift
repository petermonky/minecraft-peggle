//
//  CircleCollidable.swift
//  Peggle
//
//  Created by Peter Jung on 2023/02/22.
//

import Foundation

protocol CircleCollidable: BodyCollidable where Shape == CirclePhysicsShape {
    override var shape: CirclePhysicsShape { get }

    var radius: CGFloat { get }
}

extension CircleCollidable {
    var radius: CGFloat {
        shape.radius
    }

    func contains(_ point: CGPoint) -> Bool {
        position.distance(to: point) <= radius
    }
}
