//
//  BallGameObject.swift
//  Peggle
//
//  Created by Peter Jung on 2023/02/06.
//

import Foundation

struct BallGameObject: CircleDynamicPhysicsBody {
    var position: CGPoint
    var velocity: CGVector
    let shape: CirclePhysicsShape

    init(position: CGPoint = CGPoint.zero, velocity: CGVector = CGVector.zero) {
        self.position = position
        self.velocity = velocity
        self.shape = CirclePhysicsShape(radius: Constants.Ball.radius)
    }
}
