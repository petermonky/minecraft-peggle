//
//  DynamicBody.swift
//  Peggle
//
//  Created by Peter Jung on 2023/02/06.
//

import Foundation

enum FrameSideType: CaseIterable {
    case left
    case right
    case top
    case bottom
}

protocol DynamicPhysicsBody: PhysicsBody where Body == Self {
    associatedtype Body: PhysicsBody

    override var position: CGPoint { get set }
    override var velocity: CGVector { get set }

    func updatePosition(_ position: CGPoint)
    func updateVelocity(_ velocity: CGVector)

    func hasCollisionWith(frame: CGSize, side: FrameSideType) -> Bool
    func resolveCollisionWith(frame: CGSize, side: FrameSideType, restitution: CGFloat)
    func createCollisionDataWith(frame: CGSize, side: FrameSideType) -> CircleFrameCollisionData

    func hasCollisionWith(circleBody: any CirclePhysicsBody) -> Bool
    func resolveCollisionWith(circleBody: any CirclePhysicsBody, restitution: CGFloat)
    func createCollisionDataWith(circleBody: any CirclePhysicsBody) -> CircleCircleCollisionData
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
    func resolveCollisionWith(frame: CGSize, side: FrameSideType) {
        resolveCollisionWith(frame: frame, side: side, restitution: Constants.Physics.restitution)
    }

    func resolveCollisionWith(circleBody: any CirclePhysicsBody) {
        resolveCollisionWith(circleBody: circleBody, restitution: Constants.Physics.restitution)
    }
}
