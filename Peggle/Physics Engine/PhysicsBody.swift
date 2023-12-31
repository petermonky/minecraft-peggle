//
//  PhysicsBody.swift
//  Peggle
//
//  Created by Peter Jung on 2023/02/04.
//

import Foundation

protocol PhysicsBody: AnyObject, Identifiable, BodyCollidable, Cloneable {
    var id: String { get }
    var position: CGPoint { get set }
    var velocity: CGVector { get }
    var shape: Shape { get }

    func updatePosition(_ position: CGPoint)
}

extension PhysicsBody {
    var id: String {
        String(UInt(bitPattern: ObjectIdentifier(self)))
    }

    var velocity: CGVector {
        CGVector.zero
    }

    func updatePosition(_ position: CGPoint) {
        self.position = position
    }
}
