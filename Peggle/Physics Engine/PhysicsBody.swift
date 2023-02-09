//
//  PhysicsBody.swift
//  Peggle
//
//  Created by Peter Jung on 2023/02/04.
//

import Foundation

protocol PhysicsBody: AnyObject, Identifiable {
    associatedtype Shape: PhysicsShape

    var id: String { get }
    var position: CGPoint { get }
    var velocity: CGVector { get }
    var shape: Shape { get }

    func resolvedCollision(with other: any PhysicsBody)
    func clone() -> Self
}

extension PhysicsBody {
    var id: String {
        String(UInt(bitPattern: ObjectIdentifier(self)))
    }

    var velocity: CGVector {
        CGVector.zero
    }

    func resolvedCollision(with other: any PhysicsBody) {
    }
}
