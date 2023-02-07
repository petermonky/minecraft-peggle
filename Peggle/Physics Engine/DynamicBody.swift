//
//  DynamicBody.swift
//  Peggle
//
//  Created by Peter Jung on 2023/02/06.
//

import Foundation

protocol DynamicBody: PhysicsBody where Body == Self {
    associatedtype Body: DynamicBody

    var velocity: CGVector { get set }

    mutating func updateVelocity(_ velocity: CGVector)
    mutating func resolveCollisionWith(frame: CGSize, futureBody: Body, restitution: CGFloat)
    mutating func resolveCollisionWith(circleBody: any CirclePhysicsBody, futureBody: Body, restitution: CGFloat)
}

 extension DynamicBody {
    mutating func resolveCollisionWith(frame: CGSize, futureBody: Body) {
        resolveCollisionWith(frame: frame, futureBody: futureBody, restitution: Constants.Physics.restitution)
    }

    mutating func resolveCollisionWith(circleBody: any CirclePhysicsBody, futureBody: Body) {
        resolveCollisionWith(circleBody: circleBody, futureBody: futureBody, restitution: Constants.Physics.restitution)
    }
 }

extension DynamicBody {
    mutating func updateVelocity(_ velocity: CGVector) {
        self.velocity = velocity
    }
}
