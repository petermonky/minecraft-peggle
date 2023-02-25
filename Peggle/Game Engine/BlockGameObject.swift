//
//  BlockGameObject.swift
//  Peggle
//
//  Created by Peter Jung on 2023/02/23.
//

import Foundation

final class BlockGameObject: CollidableGameObject, PolygonPhysicsBody {
    @Published var position: CGPoint
    @Published var hasCollidedWithBall: Bool
    @Published var isVisible: Bool
    var ballCollisionCount: Int
    let shape: PolygonPhysicsShape
    let block: Block

    var isBlockingBall: Bool {
        ballCollisionCount == Constants.Peg.blockingThreshold
    }

    init(block: Block, hasCollidedWithBall: Bool = false) {
        self.position = block.position
        self.hasCollidedWithBall = hasCollidedWithBall
        self.isVisible = true
        self.ballCollisionCount = 0
        self.shape = block.shape
        self.block = block
    }

    func collideWithBall() {
        ballCollisionCount = min(ballCollisionCount + 1, Constants.Peg.blockingThreshold)
        hasCollidedWithBall = true
    }

    func clone() -> BlockGameObject {
        BlockGameObject(block: block)
    }
}

extension BlockGameObject {
    static func == (lhs: BlockGameObject, rhs: BlockGameObject) -> Bool {
        lhs.block == rhs.block
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(block)
    }
}
