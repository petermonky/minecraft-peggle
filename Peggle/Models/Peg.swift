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
}

class Peg: LevelObject {
    var id = UUID()
    var position: CGPoint
    var type: PegType
    var normalImageName: String
    var glowImageName: String

    init(type: PegType, position: CGPoint, normalImageName: String, glowImageName: String) {
        self.type = type
        self.position = position
        self.normalImageName = normalImageName
        self.glowImageName = glowImageName
    }

    func overlapsWith(peg other: Peg) -> Bool {
        self.position.distance(to: other.position) <= 2 * Constants.Peg.radius
    }

    func translateBy(_ value: CGSize) {
        position.x += value.width
        position.y += value.height
    }

    func clone() -> Peg {
        Peg(type: type, position: position, normalImageName: normalImageName, glowImageName: glowImageName)
    }
}

// MARK: Hashable

extension Peg: Hashable {
    static func == (lhs: Peg, rhs: Peg) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

class BluePeg: Peg {
    init(position: CGPoint = CGPoint.zero) {
        super.init(type: .blue, position: position, normalImageName: "peg-blue", glowImageName: "peg-blue-glow")
    }

    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
    }

    override func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
    }
}

class OrangePeg: Peg {
    init(position: CGPoint = CGPoint.zero) {
        super.init(type: .orange, position: position, normalImageName: "peg-orange", glowImageName: "peg-orange-glow")
    }

    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
    }

    override func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
    }
}
