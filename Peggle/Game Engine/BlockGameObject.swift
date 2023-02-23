//
//  BlockGameObject.swift
//  Peggle
//
//  Created by Peter Jung on 2023/02/23.
//

import Foundation

final class BlockGameObject: GameObject, PolygonPhysicsBody {
    @Published var position: CGPoint
    let shape: PolygonPhysicsShape
    let block: Block

    init(block: Block) {
        self.position = block.position
        self.block = block
        self.shape = PolygonPhysicsShape(width: Constants.Block.width, height: Constants.Block.height)
    }

    func clone() -> BlockGameObject {
        BlockGameObject(block: block)
    }
}
