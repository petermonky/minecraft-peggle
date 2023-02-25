//
//  LevelObject.swift
//  Peggle
//
//  Created by Peter Jung on 2023/02/21.
//

import Foundation
import SwiftUI

protocol LevelObject: ObservableObject, Identifiable, Codable, Hashable, Cloneable, Collidable {
    var id: UUID { get }
    var position: CGPoint { get set }
    var normalImageName: String { get }
    var width: CGFloat { get }
    var height: CGFloat { get }

    var rotationScale: CGFloat { get set }
    var sizeScale: CGFloat { get set }
    var dragOffset: CGSize { get set }
    var zIndex: Double { get set }

    func overlapsWith(_ other: any Collidable) -> Bool
    func callibrateSizeScale()
    func callibrateRotationScale()
    func translate(by value: CGVector)
    func resize(by value: CGFloat)
    func resize(to value: CGFloat)
    func rotate(by value: CGFloat)
    func rotate(to value: CGFloat)
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
    func overlapsWith(_ other: any Collidable) -> Bool {
        CollisionManager.hasCollisionBetween(self, and: other)
    }

    func translateBy(_ value: CGSize) {
        position.x += value.width
        position.y += value.height
    }
}
