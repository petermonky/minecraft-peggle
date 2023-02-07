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

    // TODO: fix hacky uuid
    init(id: UUID?, frame: CGSize = CGSize.zero, title: String = "", updatedAt: Date = Date.now, pegs: Set<Peg> = []) {
        self.id = id ?? UUID()
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
