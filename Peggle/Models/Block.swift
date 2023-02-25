//
//  Block.swift
//  Peggle
//
//  Created by Peter Jung on 2023/02/21.
//

import Foundation
import SwiftUI

class Block: LevelObject, PolygonCollidable {
    typealias Shape = PolygonPhysicsShape

    var id = UUID()
    var position: CGPoint
    var shape: Shape
    var normalImageName: String

    var width: CGFloat {
        shape.width
    }

    var height: CGFloat {
        shape.height
    }

    init(position: CGPoint, shape: Shape, normalImageName: String) {
        self.position = position
        self.shape = shape
        self.normalImageName = normalImageName
    }

    required init(instance: Block) {
        position = instance.position
        shape = instance.shape
        normalImageName = instance.normalImageName
    }

    func clone() -> Self? {
        Block(position: position, shape: shape, normalImageName: normalImageName) as? Self
    }

    func translate(by vector: CGVector) {
        position.x += vector.dx
        position.y += vector.dy
    }

    func scale(by value: CGFloat) {
        shape.scale(by: value)
    }
}

class NormalBlock: Block {
    init(position: CGPoint = CGPoint.zero) {
        super.init(
            position: position,
            shape: PolygonPhysicsShape(width: Constants.Block.width, height: Constants.Block.height),
            normalImageName: "block"
        )
    }

    required init(instance: Block) {
        super.init(instance: instance)
    }

    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
    }

    override func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
    }
}
