//
//  Peg.swift
//  Peggle
//
//  Created by Peter Jung on 2023/01/22.
//

import Foundation
import SwiftUI

enum PegType: String, Codable {
    case blue
    case red
    case green
}

class Peg: LevelObject, CircleCollidable {
    typealias Shape = CirclePhysicsShape

    var id = UUID()
    @Published var dragOffset: CGSize = .zero
    @Published var zIndex: Double = 0
    @Published var sizeScale: CGFloat = 1
    @Published var rotationScale: CGFloat = 0

    var position: CGPoint
    var shape: Shape
    var type: PegType
    var normalImageName: String
    var glowImageName: String
    var score: Int

    var width: CGFloat {
        2 * shape.radius
    }

    var height: CGFloat {
        2 * shape.radius
    }

    enum CodingKeys: String, CodingKey {
        case position
        case shape
        case type
        case normalImageName
        case glowImageName
        case score
    }

    init(type: PegType, shape: Shape, position: CGPoint, normalImageName: String, glowImageName: String, score: Int) {
        self.position = position
        self.shape = shape
        self.normalImageName = normalImageName
        self.type = type
        self.glowImageName = glowImageName
        self.score = score
        callibrateSizeScale()
        callibrateRotationScale()
    }

    required init(instance: Peg) {
        position = instance.position
        shape = instance.shape
        normalImageName = instance.normalImageName
        type = instance.type
        glowImageName = instance.glowImageName
        score = instance.score
        callibrateSizeScale()
        callibrateRotationScale()
    }

    func clone() -> Self {
        Self(instance: self)
    }

    func callibrateSizeScale() {
        sizeScale = shape.radius / Constants.Peg.radius
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

    func performCollisionAction(gameEngine: GameEngine) {
        // override
    }
}

final class BluePeg: Peg {
    init(position: CGPoint = CGPoint.zero) {
        super.init(
            type: .blue,
            shape: CirclePhysicsShape(radius: Constants.Peg.radius),
            position: position,
            normalImageName: "peg-blue",
            glowImageName: "peg-blue-glow",
            score: Constants.Peg.Blue.score
        )
    }

    required init(instance: Peg) {
        super.init(instance: instance)
    }

    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
    }

    override func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
    }
}

final class RedPeg: Peg {
    init(position: CGPoint = CGPoint.zero) {
        super.init(
            type: .red,
            shape: CirclePhysicsShape(radius: Constants.Peg.radius),
            position: position,
            normalImageName: "peg-red",
            glowImageName: "peg-red-glow",
            score: Constants.Peg.Red.score
        )
    }

    required init(instance: Peg) {
        super.init(instance: instance)
    }

    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
    }

    override func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
    }
}

final class GreenPeg: Peg {
    init(position: CGPoint = CGPoint.zero) {
        super.init(
            type: .green,
            shape: CirclePhysicsShape(radius: Constants.Peg.radius),
            position: position,
            normalImageName: "peg-green",
            glowImageName: "peg-green-glow",
            score: Constants.Peg.Green.score
        )
    }

    required init(instance: Peg) {
        super.init(instance: instance)
    }

    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
    }

    override func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
    }
}
