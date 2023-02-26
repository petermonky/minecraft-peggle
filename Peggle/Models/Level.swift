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
    static var ChristmasSpirit: Level {
        let width = 834
        let height = 764
        let frame = Frame(width: CGFloat(width), height: CGFloat(height))

        var pegs = Set<Peg>()
        (1...9).forEach { i in
            (1...7).forEach { j in
                pegs.insert(RedPeg(
                    position: CGPoint(x: i * width / 10, y: j * 100),
                    radius: Constants.Peg.radius / 2
                ))
            }
        }
        (1...9).forEach { i in
            (1...6).forEach { j in
                pegs.insert(GreenPeg(
                    position: CGPoint(x: i * width / 10, y: j * 100 + 50),
                    radius: Constants.Peg.radius
                ))
            }
        }

        let title = "Christmas Spirit"

        return Level(frame: frame, title: title, pegs: pegs)
    }

    static var BlockHell: Level {
        let width = 834
        let height = 764
        let frame = Frame(width: CGFloat(width), height: CGFloat(height))

        var pegs = Set<Peg>()
        var blocks = Set<Block>()
        (1...8).forEach {
            pegs.insert(BluePeg(
                position: CGPoint(x: $0 * width / 9, y: 300),
                radius: Constants.Peg.radius / 2
            ))
            blocks.insert(NormalBlock(
                position: CGPoint(x: $0 * width / 9, y: 200),
                width: Constants.Block.width / 2,
                height: Constants.Block.height / 2,
                rotation: .pi / 8 * CGFloat($0)
            ))
        }
        (1...7).forEach {
            pegs.insert(GreenPeg(
                position: CGPoint(x: $0 * width / 8, y: 500),
                radius: Constants.Peg.radius
            ))
            blocks.insert(NormalBlock(
                position: CGPoint(x: $0 * width / 8, y: 400),
                width: Constants.Block.width,
                height: Constants.Block.height,
                rotation: .pi / 8 * CGFloat($0 + 1)
            ))
        }
        (1...6).forEach {
            pegs.insert(RedPeg(
                position: CGPoint(x: $0 * width / 7, y: 700),
                radius: Constants.Peg.radius * 1.5
            ))
            blocks.insert(NormalBlock(
                position: CGPoint(x: $0 * width / 7, y: 600),
                width: Constants.Block.width * 1.5,
                height: Constants.Block.height * 1.5,
                rotation: .pi / 8 * CGFloat($0 + 2)
            ))
        }

        let title = "Block Hell"

        return Level(frame: frame, title: title, pegs: pegs, blocks: blocks)
    }

    static var PeggleShowdown: Level {
        let width = 834
        let height = 764
        let frame = Frame(width: CGFloat(width), height: CGFloat(height))

        var pegs = Set<Peg>()
        (1...4).forEach {
            pegs.insert(BluePeg(position: CGPoint(x: $0 * width / 5, y: 150)))
        }
        (1...6).forEach {
            pegs.insert(GreenPeg(position: CGPoint(x: $0 * width / 7, y: 300)))
        }
        (1...8).forEach {
            pegs.insert(RedPeg(position: CGPoint(x: $0 * width / 9, y: 450)))
        }
        var blocks = Set<Block>()
        (1...10).forEach {
            blocks.insert(NormalBlock(position: CGPoint(x: $0 * width / 11, y: 600)))
        }

        let title = "Peggle Showdown"

        return Level(frame: frame, title: title, pegs: pegs, blocks: blocks)
    }
}
