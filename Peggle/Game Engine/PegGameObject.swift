//
//  PegGameObject.swift
//  Peggle
//
//  Created by Peter Jung on 2023/02/05.
//

import Foundation

final class PegGameObject: GameObject, Equatable, CirclePhysicsBody {
    @Published var position: CGPoint
    @Published var hasCollidedWithBall: Bool
    @Published var isVisible: Bool
    private var ballCollisionCount: Int
    let shape: CirclePhysicsShape
    let peg: Peg

    var isBlockingBall: Bool {
        ballCollisionCount == Constants.Peg.blockingThreshold
    }

    init(peg: Peg = BluePeg(), hasCollidedWithBall: Bool = false) {
        self.position = peg.position
        self.hasCollidedWithBall = hasCollidedWithBall
        self.isVisible = true
        self.ballCollisionCount = 0
        self.shape = CirclePhysicsShape(radius: Constants.Peg.radius)
        self.peg = peg
    }

    func collideWithBall() {
        ballCollisionCount = min(ballCollisionCount + 1, Constants.Peg.blockingThreshold)
        hasCollidedWithBall = true
    }

    func clone() -> PegGameObject {
        PegGameObject(peg: peg, hasCollidedWithBall: hasCollidedWithBall)
    }
}

extension PegGameObject {
    static func == (lhs: PegGameObject, rhs: PegGameObject) -> Bool {
        lhs.peg == rhs.peg
    }
}
