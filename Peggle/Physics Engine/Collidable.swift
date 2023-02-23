//
//  File.swift
//  Peggle
//
//  Created by Peter Jung on 2023/02/22.
//

import Foundation

protocol Collidable {
    associatedtype Shape: PhysicsShape

    var position: CGPoint { get }
    var shape: Shape { get }

    func contains(_ point: CGPoint) -> Bool
}
