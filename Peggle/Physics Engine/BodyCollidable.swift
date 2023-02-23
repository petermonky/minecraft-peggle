//
//  BodyCollidable.swift
//  Peggle
//
//  Created by Peter Jung on 2023/02/23.
//

import Foundation

protocol BodyCollidable: AnyObject, Identifiable, Collidable {
    associatedtype Shape: PhysicsShape

    var position: CGPoint { get }
    var shape: Shape { get }

    func contains(_ point: CGPoint) -> Bool
}
