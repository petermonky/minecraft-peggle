//
//  Level.swift
//  Peggle
//
//  Created by Peter Jung on 2023/01/24.
//

import Foundation

struct Level: Identifiable, Codable {
    var id: UUID
    var frame: CGSize
    var title: String
    var updatedAt: Date
    var pegs: Set<Peg>
    var blocks: Set<Block>

    init(
        id: UUID = UUID(),
        frame: CGSize = CGSize.zero,
        title: String = "",
        updatedAt: Date = Date.now,
        pegs: Set<Peg> = [],
        blocks: Set<Block> = []
    ) {
        self.id = id
        self.frame = frame
        self.title = title
        self.updatedAt = updatedAt
        self.pegs = pegs
        self.blocks = blocks
    }
}

// MARK: Hashable

extension Level: Hashable {
    static func == (lhs: Level, rhs: Level) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension Level {
    static var mockData: Level {
        // Optimised for iPad Pro (11-inch) (4th generation)
        let frame = CGSize(width: 834.0, height: 894.0)
        var pegs = Set<Peg>()
//        (1...10).forEach {
//            pegs.insert(BluePeg(position: CGPoint(x: $0 * 150 - 75, y: 200)))
//            pegs.insert(OrangePeg(position: CGPoint(x: $0 * 120 - 60, y: 400)))
//        }
        var blocks = Set<Block>()
        (1...10).forEach {
            blocks.insert(NormalBlock(position: CGPoint(x: $0 * 90 - 45, y: 600)))
        }
        let title = "Mock level"

        return Level(frame: frame, title: title, pegs: pegs, blocks: blocks)
    }
}
