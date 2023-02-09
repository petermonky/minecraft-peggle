//
//  PhysicsWorld.swift
//  Peggle
//
//  Created by Peter Jung on 2023/02/04.
//

import Foundation

class PhysicsWorld {
    let frame: CGSize
    let gravity: CGVector
    private(set) var bodies: [any PhysicsBody]
    private(set) var collisionData: [any CollisionData]

    init(
        frame: CGSize = CGSize(),
        gravity: CGVector = Constants.Physics.gravity,
        bodies: [any PhysicsBody] = [],
        collisionData: [any CollisionData] = []
    ) {
        self.frame = frame
        self.gravity = gravity
        self.bodies = bodies
        self.collisionData = collisionData
    }

    var circlePhysicsBodies: [any CirclePhysicsBody] {
        bodies.compactMap { $0 as? any CirclePhysicsBody }
    }

    func addBody(_ body: any PhysicsBody) {
        bodies.append(body)
    }

    func removeBody(_ body: any PhysicsBody) {
        bodies.removeAll(where: { $0 === body })
    }

    func update(delta: TimeInterval) {
        handleSteps(delta: delta)
        handleCollisions(delta: delta)
    }

    private func handleSteps(delta: TimeInterval) {
        for body in bodies {
            guard let body = body as? any DynamicPhysicsBody else {
                continue
            }
            applyStep(body: body, delta: delta)
        }
    }

    private func handleCollisions(delta: TimeInterval) {
        collisionData.removeAll()

        for body in bodies {
            guard let body = body as? (any DynamicPhysicsBody) else {
                continue
            }
            applyFrameCollisionBetween(body, and: frame, delta: delta)
            for other in bodies where body !== other {
                if let circleBody = other as? (any CirclePhysicsBody) {
                    applyCircleBodyCollisionBetween(body, and: circleBody, delta: delta)
                } else {
                    fatalError("Invalid body")
                } // TODO: else if polygon
            }
        }
    }

    private func applyStep<T: DynamicPhysicsBody>(body: T, delta: TimeInterval) {
        applyGravity(body: body, delta: delta)
        applyVelocity(body: body, delta: delta)
    }

    private func applyGravity<T: DynamicPhysicsBody>(body: T, delta: TimeInterval) {
        let velocity = body.velocity.add(by: gravity.scale(by: delta))
        body.updateVelocity(velocity)
    }

    private func applyVelocity<T: DynamicPhysicsBody>(body: T, delta: TimeInterval) {
        let position = body.position.move(by: body.velocity.scale(by: delta))
        body.updatePosition(position)
    }

    private func applyFrameCollisionBetween<T: DynamicPhysicsBody>(
        _ body: T,
        and frame: CGSize,
        delta: TimeInterval
    ) {
        let futureBody = body.clone()
        applyStep(body: futureBody, delta: delta)

        for side in FrameSideType.allCases where futureBody.hasCollisionWith(frame: frame, side: side) {
            collisionData.append(body.createCollisionDataWith(frame: frame, side: side))
            body.resolveCollisionWith(frame: frame, side: side)
        }
    }

    private func applyCircleBodyCollisionBetween<T: DynamicPhysicsBody>(
        _ body: T,
        and circleBody: any CirclePhysicsBody,
        delta: TimeInterval
    ) {
        let futureBody = body.clone()
        applyStep(body: futureBody, delta: delta)

        if futureBody.hasCollisionWith(circleBody: circleBody) {
            collisionData.append(body.createCollisionDataWith(circleBody: circleBody))
            body.resolveCollisionWith(circleBody: circleBody)
        }
    }
}
