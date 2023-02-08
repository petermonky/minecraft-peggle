//
//  PegGameObject.swift
//  Peggle
//
//  Created by Peter Jung on 2023/02/05.
//

import Foundation

final class PegGameObject: CirclePhysicsBody {
    var position: CGPoint
    var hasCollidedWithBall: Bool
    let shape: CirclePhysicsShape
    let peg: Peg

    init(peg: Peg = BluePeg(), hasCollidedWithBall: Bool = false) {
        self.position = peg.position
        self.hasCollidedWithBall = hasCollidedWithBall
        self.shape = CirclePhysicsShape(radius: Constants.Peg.radius)
        self.peg = peg
    }

    func resolvedCollision(with other: any PhysicsBody) {
        if other is BallGameObject {
            hasCollidedWithBall = true
        }
    }

    func clone() -> PegGameObject {
        PegGameObject(peg: peg, hasCollidedWithBall: hasCollidedWithBall)
    }
}
