//
//  Peg.swift
//  Peggle
//
//  Created by Peter Jung on 2023/01/22.
//

import Foundation
import SwiftUI

enum PegType: String, Codable {
    case blue = "peg-blue"
    case orange = "peg-orange"
}

class Peg: Identifiable, Codable {
    var id = UUID()
    var type: PegType
    var position: CGPoint

    var imageName: String {
        type.rawValue
    }

    init(type: PegType, position: CGPoint) {
        self.type = type
        self.position = position
    }

    func overlapsWith(peg other: Peg) -> Bool {
        self.position.distance(to: other.position) <= 2 * Constants.Peg.radius
    }

    func translateBy(_ value: CGSize) {
        position.x += value.width
        position.y += value.height
    }

    func clone() -> Peg {
        Peg(type: type, position: position)
    }

    enum CodingKeys: String, CodingKey {
        case type, position
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
        super.init(type: .blue, position: position)
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
        super.init(type: .orange, position: position)
    }

    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
    }

    override func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
    }
}
