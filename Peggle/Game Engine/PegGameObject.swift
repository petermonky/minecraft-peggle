//
//  PegGameObject.swift
//  Peggle
//
//  Created by Peter Jung on 2023/02/05.
//

import Foundation

class PegGameObject: CollidableGameObject, CirclePhysicsBody {
    @Published var position: CGPoint
    @Published var hasCollidedWithBall: Bool
    @Published var isVisible: Bool
    weak var gameEngine: GameEngine?
    var ballCollisionCount: Int
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
        self.shape = peg.shape
        self.peg = peg
    }

    required init(instance: PegGameObject) {
        self.position = instance.position
        self.hasCollidedWithBall = instance.hasCollidedWithBall
        self.isVisible = instance.isVisible
        self.ballCollisionCount = instance.ballCollisionCount
        self.shape = instance.shape
        self.peg = instance.peg
    }

    func clone() -> Self {
        Self(instance: self)
    }

    func collideWithBall() {
        if let gameEngine = gameEngine, !hasCollidedWithBall {
            peg.performCollisionAction(gameEngine: gameEngine)
        }
        ballCollisionCount = min(ballCollisionCount + 1, Constants.Peg.blockingThreshold)
        hasCollidedWithBall = true
    }
}

extension PegGameObject {
    static func == (lhs: PegGameObject, rhs: PegGameObject) -> Bool {
        lhs.peg == rhs.peg
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(peg)
    }
}
