//
//  DynamicBody.swift
//  Peggle
//
//  Created by Peter Jung on 2023/02/06.
//

import Foundation

protocol DynamicPhysicsBody: PhysicsBody where Body == Self {
    associatedtype Body: PhysicsBody

    override var position: CGPoint { get set }
    override var velocity: CGVector { get set }

    mutating func updatePosition(_ position: CGPoint)
    mutating func updateVelocity(_ velocity: CGVector)
    mutating func resolveCollisionWith(frame: CGSize, futureBody: Body, restitution: CGFloat)
    mutating func resolveCollisionWith(circleBody: any CirclePhysicsBody, futureBody: Body, restitution: CGFloat)
}

extension DynamicPhysicsBody {
    mutating func updatePosition(_ position: CGPoint) {
        self.position = position
    }

    mutating func updateVelocity(_ velocity: CGVector) {
        self.velocity = velocity
    }
}

extension DynamicPhysicsBody {
    mutating func resolveCollisionWith(frame: CGSize, futureBody: Body) {
        resolveCollisionWith(frame: frame, futureBody: futureBody, restitution: Constants.Physics.restitution)
    }

    mutating func resolveCollisionWith(circleBody: any CirclePhysicsBody, futureBody: Body) {
        resolveCollisionWith(circleBody: circleBody, futureBody: futureBody, restitution: Constants.Physics.restitution)
    }
}
