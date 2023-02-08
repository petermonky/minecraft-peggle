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
    private func handleLeftSideCollisionWith(frame: CGSize, futureBody: Body, restitution: CGFloat) {
        if futureBody.position.x - shape.radius < 0 {
            position.x = shape.radius
            velocity = velocity.reflectAlongXAxis().scale(by: restitution)
        }
    }

    private func handleRightSideCollisionWith(frame: CGSize, futureBody: Body, restitution: CGFloat) {
        if futureBody.position.x + shape.radius > frame.width {
            position.x = frame.width - shape.radius
            velocity = velocity.reflectAlongXAxis().scale(by: restitution)
        }
    }

    private func handleTopSideCollisionWith(frame: CGSize, futureBody: Body, restitution: CGFloat) {
        if futureBody.position.y - shape.radius < 0 {
            position.y = shape.radius
            velocity = velocity.reflectAlongYAxis().scale(by: restitution)
        }
    }

    private func handleBottomSideCollisionWith(frame: CGSize, futureBody: Body, restitution: CGFloat) {
        if futureBody.position.y + shape.radius > frame.height {
            position.y = frame.height - shape.radius
            velocity = velocity.reflectAlongYAxis().scale(by: restitution)
        }
    }

    func resolveCollisionWith(frame: CGSize, futureBody: Body, restitution: CGFloat) {
        handleLeftSideCollisionWith(frame: frame, futureBody: futureBody, restitution: restitution)
        handleRightSideCollisionWith(frame: frame, futureBody: futureBody, restitution: restitution)
        handleTopSideCollisionWith(frame: frame, futureBody: futureBody, restitution: restitution)
        handleBottomSideCollisionWith(frame: frame, futureBody: futureBody, restitution: restitution)
    }
}

// MARK: Circle body collision

extension CircleDynamicPhysicsBody {
    func hasCollisionWith(circleBody: any CirclePhysicsBody) -> Bool {
        position.distance(to: circleBody.position) <= (shape.radius + circleBody.shape.radius)
    }

    // TODO: fledge out collision resolution logic
    func resolveCollisionWith(circleBody: any CirclePhysicsBody, futureBody: Body, restitution: CGFloat) {
        guard futureBody.hasCollisionWith(circleBody: circleBody) else {
            return
        }
        let normalised = CGVector(from: circleBody.position, to: position).normalise
        let scaled = normalised.scale(by: shape.radius + circleBody.shape.radius)
        position = circleBody.position.move(by: scaled)
        velocity = velocity.reflectAlongVector(scaled).scale(by: restitution)
        circleBody.resolvedCollision(with: self)
    }
}
