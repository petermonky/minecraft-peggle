//
//  DynamicCirclePhysicsBody.swift
//  Peggle
//
//  Created by Peter Jung on 2023/02/07.
//

import Foundation

protocol CircleDynamicPhysicsBody: CirclePhysicsBody, DynamicBody {
}

// MARK: Frame collision

extension CircleDynamicPhysicsBody {
    private mutating func handleLeftSideCollisionWith(frame: CGSize, futureBody: Body, restitution: CGFloat) {
        if futureBody.position.x - shape.radius < 0 {
            position.x = shape.radius
            velocity = velocity.reflectAlongXAxis().scale(by: restitution)
        }
    }

    private mutating func handleRightSideCollisionWith(frame: CGSize, futureBody: Body, restitution: CGFloat) {
        if futureBody.position.x + shape.radius > frame.width {
            position.x = frame.width - shape.radius
            velocity = velocity.reflectAlongXAxis().scale(by: restitution)
        }
    }

    private mutating func handleTopSideCollisionWith(frame: CGSize, futureBody: Body, restitution: CGFloat) {
        if futureBody.position.y - shape.radius < 0 {
            position.y = shape.radius
            velocity = velocity.reflectAlongYAxis().scale(by: restitution)
        }
    }

    private mutating func handleBottomSideCollisionWith(frame: CGSize, futureBody: Body, restitution: CGFloat) {
        if futureBody.position.y + shape.radius > frame.height {
            position.y = frame.height - shape.radius
            velocity = velocity.reflectAlongYAxis().scale(by: restitution)
        }
    }

    mutating func resolveCollisionWith(frame: CGSize, futureBody: Body, restitution: CGFloat) {
        handleLeftSideCollisionWith(frame: frame, futureBody: futureBody, restitution: restitution)
        handleRightSideCollisionWith(frame: frame, futureBody: futureBody, restitution: restitution)
        handleTopSideCollisionWith(frame: frame, futureBody: futureBody, restitution: restitution)
        handleBottomSideCollisionWith(frame: frame, futureBody: futureBody, restitution: restitution)
    }
}

// MARK: Circle body collision

extension CircleDynamicPhysicsBody {
    private func hasCollisionWith(circleBody: any CirclePhysicsBody) -> Bool {
        position.distance(to: circleBody.position) <= (shape.radius + circleBody.shape.radius)
    }

    mutating func resolveCollisionWith(circleBody: any CirclePhysicsBody, futureBody: Body, restitution: CGFloat) {
        if futureBody.hasCollisionWith(circleBody: circleBody) {
            let normalised = CGVector(from: circleBody.position, to: position).normalise
            let scaled = normalised.scale(by: shape.radius + circleBody.shape.radius)
            velocity = velocity.reflectAlongVector(scaled).scale(by: restitution)
            position = circleBody.position.move(by: scaled)
        }
    }
}
