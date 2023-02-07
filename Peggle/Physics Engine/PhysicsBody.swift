//
//  PhysicsBody.swift
//  Peggle
//
//  Created by Peter Jung on 2023/02/04.
//

import Foundation

protocol PhysicsBody {
    associatedtype Shape: PhysicsShape

    var position: CGPoint { get set }
    var shape: Shape { get }

    mutating func updatePosition(_ position: CGPoint)
}

extension PhysicsBody {
    mutating func updatePosition(_ position: CGPoint) {
        self.position = position
    }
}
