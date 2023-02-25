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
    @Published var dragOffset: CGSize = .zero
    @Published var zIndex: Double = 0
    @Published var sizeScale: CGFloat = 1
    @Published var rotationScale: CGFloat = 0

    var position: CGPoint
    var shape: Shape
    var normalImageName: String

    var width: CGFloat {
        shape.width
    }

    var height: CGFloat {
        shape.height
    }

    enum CodingKeys: String, CodingKey {
        case position
        case shape
        case normalImageName
    }

    init(position: CGPoint, shape: Shape, normalImageName: String) {
        self.position = position
        self.shape = shape
        self.normalImageName = normalImageName
        callibrateSizeScale()
        callibrateRotationScale()
    }

    required init(instance: Block) {
        position = instance.position
        shape = instance.shape
        normalImageName = instance.normalImageName
        callibrateSizeScale()
        callibrateRotationScale()
    }

    func callibrateSizeScale() {
        sizeScale = shape.width / Constants.Block.width // TODO: better handling
    }

    func callibrateRotationScale() {
        rotationScale = shape.rotation
    }

    func translate(by vector: CGVector) {
        position.x += vector.dx
        position.y += vector.dy
    }

    func resize(by value: CGFloat) {
        shape.scale(by: value)
        callibrateSizeScale()
    }

    func resize(to value: CGFloat) {
        resize(by: value / sizeScale)
    }

    func rotate(by value: CGFloat) {
        shape.rotate(by: value)
        callibrateRotationScale()
    }

    func rotate(to value: CGFloat) {
        rotate(by: value - shape.rotation)
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
