//
//  CollidableGameObject.swift
//  Peggle
//
//  Created by Peter Jung on 2023/02/09.
//

import Foundation

protocol CollidableGameObject: ObservableObject, Hashable, PhysicsBody {
    var hasCollidedWithBall: Bool { get }
    var isVisible: Bool { get set }
    var ballCollisionCount: Int { get }
    var isBlockingBall: Bool { get }

    func collideWithBall()
}
