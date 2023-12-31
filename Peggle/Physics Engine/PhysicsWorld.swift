//
//  PhysicsWorld.swift
//  Peggle
//
//  Created by Peter Jung on 2023/02/04.
//

import Foundation

class PhysicsWorld {
    let gravity: CGVector
    private(set) var frame: Frame
    private(set) var bodies: [any PhysicsBody]
    private(set) var collisionData: [any CollisionData]

    init(
        frame: Frame = Frame(),
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

    func adjustFrame(x: CGFloat = .zero, y: CGFloat = .zero) {
        frame = frame.adjust(x: x, y: y)
    }

    func addBody(_ body: any PhysicsBody) {
        bodies.append(body)
    }

    func removeBody(_ body: any PhysicsBody) {
        bodies.removeAll(where: { $0 === body })
    }

    func update(delta: TimeInterval) {
        handleCollisions(delta: delta)
        handleSteps(delta: delta)
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
                applyBodyCollisionBetween(body, and: other, delta: delta)
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
        and frame: Frame,
        delta: TimeInterval
    ) {
        let futureBody = body.clone()
        applyStep(body: futureBody, delta: delta)
        if CollisionManager.hasCollisionBetween(futureBody, and: frame),
           let data = CollisionManager.resolveCollisionBetween(body: body, frame: frame) {
            collisionData.append(data)
        }
    }

    private func applyBodyCollisionBetween<T: DynamicPhysicsBody>(
        _ body: T,
        and other: any PhysicsBody,
        delta: TimeInterval
    ) {
        let futureBody = body.clone()
        applyStep(body: futureBody, delta: delta)

        if CollisionManager.hasCollisionBetween(futureBody, and: other),
           let data = CollisionManager.resolveCollisionBetween(body, and: other) {
            collisionData.append(data)
        }
    }
}
