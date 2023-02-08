//
//  PhysicsBody.swift
//  Peggle
//
//  Created by Peter Jung on 2023/02/04.
//

import Foundation

protocol PhysicsBody: AnyObject {
    associatedtype Shape: PhysicsShape

    var position: CGPoint { get }
    var velocity: CGVector { get }
    var shape: Shape { get }

    func resolvedCollision(with other: any PhysicsBody)
    func clone() -> Self
}

extension PhysicsBody {
    var velocity: CGVector {
        CGVector.zero
    }

    func resolvedCollision(with other: any PhysicsBody) {
    }
}
