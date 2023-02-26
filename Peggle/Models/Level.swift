//
//  Level.swift
//  Peggle
//
//  Created by Peter Jung on 2023/01/24.
//

import Foundation

struct Level: Identifiable, Codable, Cloneable {
    var id: UUID
    var frame: Frame
    var title: String
    var updatedAt: Date
    var pegs: Set<Peg>
    var blocks: Set<Block>

    init(
        id: UUID = UUID(),
        frame: Frame = Frame(),
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

    init(instance: Level) {
        self.id = instance.id
        self.frame = instance.frame
        self.title = instance.title
        self.updatedAt = instance.updatedAt
        self.pegs = Set(instance.pegs.map { $0.clone() })
        self.blocks = Set(instance.blocks.map { $0.clone() })
    }

    func clone() -> Self {
        Self(instance: self)
    }

    mutating func scaledToFit(frame: Frame) {
        let widthRatio = frame.width / self.frame.width
        let heightRatio = frame.height / self.frame.height

        let value = min(widthRatio, heightRatio)
        scale(by: value)

        let widthOffset = (frame.width - value * self.frame.width) / 2
        let heightOffset = (frame.height - value * self.frame.height) / 2
        translate(by: CGVector(dx: widthOffset, dy: heightOffset))
        self.frame = frame
    }

    func scale(by value: CGFloat) {
        for peg in pegs {
            peg.resize(by: value)
            let originToPosition = CGVector(from: CGPoint.zero, to: peg.position)
            let translationVector = originToPosition.scale(by: value).subtract(by: originToPosition)
            peg.translate(by: translationVector)
        }
        for block in blocks {
            block.resize(by: value)
            let originToPosition = CGVector(from: CGPoint.zero, to: block.position)
            let translationVector = originToPosition.scale(by: value).subtract(by: originToPosition)
            block.translate(by: translationVector)
        }
    }

    func translate(by vector: CGVector) {
        for peg in pegs {
            peg.translate(by: vector)
        }
        for block in blocks {
            block.translate(by: vector)
        }
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
        let frame = Frame(width: 1_834.0, height: 1_894.0)
        var pegs = Set<Peg>()
        (1...10).forEach {
            pegs.insert(BluePeg(position: CGPoint(x: $0 * 150 - 75, y: 200)))
            pegs.insert(RedPeg(position: CGPoint(x: $0 * 120 - 60, y: 400)))
        }
        var blocks = Set<Block>()
        (1...10).forEach {
            blocks.insert(NormalBlock(position: CGPoint(x: $0 * 90 - 45, y: 600)))
        }
        let title = "Mock level"

        return Level(frame: frame, title: title, pegs: pegs, blocks: blocks)
    }
}
