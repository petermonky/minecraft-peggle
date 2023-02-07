//
//  PhysicsBody.swift
//  Peggle
//
//  Created by Peter Jung on 2023/02/04.
//

import Foundation

protocol PhysicsBody {
    associatedtype Shape: PhysicsShape

    var position: CGPoint { get }
    var velocity: CGVector { get }
    var shape: Shape { get }
}

extension PhysicsBody {
    var velocity: CGVector {
        CGVector.zero
    }
}
