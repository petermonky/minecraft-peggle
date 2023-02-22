//
//  Block.swift
//  Peggle
//
//  Created by Peter Jung on 2023/02/21.
//

import Foundation
import SwiftUI

class Block: LevelObject {
    var id = UUID()
    var position: CGPoint
    var normalImageName: String

    init(position: CGPoint, normalImageName: String) {
        self.position = position
        self.normalImageName = normalImageName
    }

    func overlapsWith(peg other: Peg) -> Bool {
        self.position.distance(to: other.position) <= 2 * Constants.Peg.radius
    }

    func translateBy(_ value: CGSize) {
        position.x += value.width
        position.y += value.height
    }

    func clone() -> Block {
        Block(position: position, normalImageName: normalImageName)
    }
}

// MARK: Hashable

extension Block: Hashable {
    static func == (lhs: Block, rhs: Block) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

class NormalBlock: Block {
    init(position: CGPoint = CGPoint.zero) {
        super.init(position: position, normalImageName: "block")
    }

    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
    }

    override func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
    }
}
