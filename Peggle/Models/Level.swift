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

    init(
        id: UUID = UUID(),
        frame: CGSize = CGSize.zero,
        title: String = "",
        updatedAt: Date = Date.now,
        pegs: Set<Peg> = []
    ) {
        self.id = id
        self.frame = frame
        self.title = title
        self.updatedAt = updatedAt
        self.pegs = pegs
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
        let frame = CGSize(width: 834.0, height: 984.0)
        var pegs = Set<Peg>()
        (1...10).forEach {
            pegs.insert(BluePeg(position: CGPoint(x: $0 * 150 - 75, y: 200)))
            pegs.insert(OrangePeg(position: CGPoint(x: $0 * 120 - 60, y: 400)))
            pegs.insert(BluePeg(position: CGPoint(x: $0 * 90 - 45, y: 600)))
        }
        let title = "Mock level"

        return Level(frame: frame, title: title, pegs: pegs)
    }
}
