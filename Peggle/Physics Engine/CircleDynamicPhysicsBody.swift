//
//  DynamicCirclePhysicsBody.swift
//  Peggle
//
//  Created by Peter Jung on 2023/02/07.
//

import Foundation

protocol CircleDynamicPhysicsBody: CirclePhysicsBody, DynamicPhysicsBody {
}

// MARK: Frame collision

extension CircleDynamicPhysicsBody {
    func hasCollisionWith(frame: CGSize, side: FrameSideType) -> Bool {
        switch side {
        case .left:
            return position.x - shape.radius < 0
        case .right:
            return position.x + shape.radius > frame.width
        case .top:
            return position.y - shape.radius < 0
        case .bottom:
            return position.y + shape.radius > frame.height
        }
    }

    func resolveCollisionWith(frame: CGSize, side: FrameSideType, restitution: CGFloat) {
        switch side {
        case .left:
            position.x = shape.radius
            velocity = velocity.reflectAlongXAxis().scale(by: restitution)
        case .right:
            position.x = frame.width - shape.radius
            velocity = velocity.reflectAlongXAxis().scale(by: restitution)
        case .top:
            position.y = shape.radius
            velocity = velocity.reflectAlongYAxis().scale(by: restitution)
        case .bottom:
            position.y = frame.height - shape.radius
            velocity = velocity.reflectAlongYAxis().scale(by: restitution)
        }
    }

    func createCollisionDataWith(frame: CGSize, side: FrameSideType) -> CircleFrameCollisionData {
        CircleFrameCollisionData(circleBody: self, side: side)
    }
}

// MARK: Circle body collision

extension CircleDynamicPhysicsBody {
    func hasCollisionWith(circleBody: any CirclePhysicsBody) -> Bool {
        position.distance(to: circleBody.position) <= (shape.radius + circleBody.shape.radius)
    }

    // TODO: fledge out collision resolution logic
    func resolveCollisionWith(circleBody: any CirclePhysicsBody, restitution: CGFloat) {
        let normalised = CGVector(from: circleBody.position, to: position).normalise
        let scaled = normalised.scale(by: shape.radius + circleBody.shape.radius)

        position = circleBody.position.move(by: scaled)
        velocity = velocity.reflectAlongVector(scaled).scale(by: restitution)
        circleBody.resolvedCollision(with: self)
    }

    func createCollisionDataWith(circleBody: any CirclePhysicsBody) -> CircleCircleCollisionData {
        CircleCircleCollisionData(first: self, second: circleBody)
    }
}
