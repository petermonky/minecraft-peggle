//
//  PegGameObject.swift
//  Peggle
//
//  Created by Peter Jung on 2023/02/05.
//

import Foundation

struct PegGameObject: CirclePhysicsBody, BallCollidable {
    var position: CGPoint
    var hasCollidedWithBall: Bool
    let shape: CirclePhysicsShape
    let peg: Peg

    init(peg: Peg = BluePeg()) {
        self.position = peg.position
        self.hasCollidedWithBall = false
        self.shape = CirclePhysicsShape(radius: Constants.Peg.radius)
        self.peg = peg
    }

    mutating func resolvedCollisionWithBall(_ ball: BallGameObject?) {
        self.hasCollidedWithBall = true
    }
}
