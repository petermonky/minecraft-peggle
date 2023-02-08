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

    func updatePosition(_ position: CGPoint)
    func updateVelocity(_ velocity: CGVector)
    func resolveCollisionWith(frame: CGSize, futureBody: Body, restitution: CGFloat)
    func resolveCollisionWith(circleBody: any CirclePhysicsBody, futureBody: Body, restitution: CGFloat)
}

extension DynamicPhysicsBody {
    func updatePosition(_ position: CGPoint) {
        self.position = position
    }

    func updateVelocity(_ velocity: CGVector) {
        self.velocity = velocity
    }
}

extension DynamicPhysicsBody {
    func resolveCollisionWith(frame: CGSize, futureBody: Body) {
        resolveCollisionWith(frame: frame, futureBody: futureBody, restitution: Constants.Physics.restitution)
    }

    func resolveCollisionWith(circleBody: any CirclePhysicsBody, futureBody: Body) {
        resolveCollisionWith(circleBody: circleBody, futureBody: futureBody, restitution: Constants.Physics.restitution)
    }
}
