//
//  CircleCollidable.swift
//  Peggle
//
//  Created by Peter Jung on 2023/02/22.
//

import Foundation

protocol CircleCollidable: Collidable where Shape == CirclePhysicsShape {
    override var shape: CirclePhysicsShape { get }
}

extension CircleCollidable {
    func contains(_ point: CGPoint) -> Bool {
        position.distance(to: point) <= shape.radius
    }
}
