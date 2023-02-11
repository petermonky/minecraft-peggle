//
//  PhysicsShape.swift
//  Peggle
//
//  Created by Peter Jung on 2023/02/06.
//

import Foundation

protocol PhysicsShape: Equatable {
    var center: CGPoint { get }
}

extension PhysicsShape {
    var center: CGPoint {
        CGPoint.zero
    }
}
