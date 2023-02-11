//
//  DynamicBody.swift
//  Peggle
//
//  Created by Peter Jung on 2023/02/06.
//

import Foundation

enum FrameSide: CaseIterable {
    case left
    case right
    case top
    case bottom
}

protocol DynamicPhysicsBody: PhysicsBody where Body == Self {
    associatedtype Body: PhysicsBody

    override var velocity: CGVector { get set }

    func updateVelocity(_ velocity: CGVector)

    func hasCollisionWith(frame: CGSize, side: FrameSide) -> Bool
    func resolveCollisionWith(frame: CGSize, side: FrameSide, restitution: CGFloat)
    func createCollisionDataWith(frame: CGSize, side: FrameSide) -> CircleFrameCollisionData

    func hasCollisionWith(circleBody: any CirclePhysicsBody) -> Bool
    func resolveCollisionWith(circleBody: any CirclePhysicsBody, restitution: CGFloat)
    func createCollisionDataWith(circleBody: any CirclePhysicsBody) -> CircleCircleCollisionData
}

extension DynamicPhysicsBody {
    func updateVelocity(_ velocity: CGVector) {
        self.velocity = velocity
    }

    func resolveCollisionWith(frame: CGSize, side: FrameSide) {
        resolveCollisionWith(frame: frame, side: side, restitution: Constants.Physics.restitution)
    }

    func resolveCollisionWith(circleBody: any CirclePhysicsBody) {
        resolveCollisionWith(circleBody: circleBody, restitution: Constants.Physics.restitution)
    }
}
