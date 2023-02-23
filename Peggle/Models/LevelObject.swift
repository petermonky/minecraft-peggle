//
//  LevelObject.swift
//  Peggle
//
//  Created by Peter Jung on 2023/02/21.
//

import Foundation
import SwiftUI

protocol LevelObject: AnyObject, Identifiable, Codable, Hashable, Cloneable, Collidable {
    var id: UUID { get }
    var position: CGPoint { get set }
    var normalImageName: String { get }
    var width: CGFloat { get }
    var height: CGFloat { get }
}

extension LevelObject {
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension LevelObject {
    func overlapsWith(_ other: any LevelObject) -> Bool {
        CollisionManager.hasCollisionBetween(self, other)
    }

    func translateBy(_ value: CGSize) {
        position.x += value.width
        position.y += value.height
    }
}
