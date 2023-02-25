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
    case orange
    case green
}

class Peg: LevelObject, CircleCollidable {
    typealias Shape = CirclePhysicsShape

    var id = UUID()
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

    init(type: PegType, shape: Shape, position: CGPoint, normalImageName: String, glowImageName: String, score: Int) {
        self.position = position
        self.shape = shape
        self.normalImageName = normalImageName
        self.type = type
        self.glowImageName = glowImageName
        self.score = score
    }

    required init(instance: Peg) {
        position = instance.position
        shape = instance.shape
        normalImageName = instance.normalImageName
        type = instance.type
        glowImageName = instance.glowImageName
        self.score = instance.score
    }

    func translate(by vector: CGVector) {
        position.x += vector.dx
        position.y += vector.dy
    }

    func scale(by value: CGFloat) {
        shape.scale(by: value)
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

final class OrangePeg: Peg {
    init(position: CGPoint = CGPoint.zero) {
        super.init(
            type: .orange,
            shape: CirclePhysicsShape(radius: Constants.Peg.radius),
            position: position,
            normalImageName: "peg-orange",
            glowImageName: "peg-orange-glow",
            score: Constants.Peg.Orange.score
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
