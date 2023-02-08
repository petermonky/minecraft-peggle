//
//  PhysicsWorld.swift
//  Peggle
//
//  Created by Peter Jung on 2023/02/04.
//

import Foundation

class PhysicsWorld {
    var frame: CGSize
    var gravity: CGVector
    var bodies: [any PhysicsBody]

    init(frame: CGSize = CGSize(),
         gravity: CGVector = CGVector(dx: 0, dy: 980.0), // TODO: move gravity to constants
         bodies: [any PhysicsBody] = []) {
        self.frame = frame
        self.gravity = gravity
        self.bodies = bodies
    }

    var circlePhysicsBodies: [any CirclePhysicsBody] {
        bodies.compactMap { $0 as? any CirclePhysicsBody }
    }

    func addBody(_ body: any PhysicsBody) {
        bodies.append(body)
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
        for i in 0..<bodies.count {
            guard let body = bodies[i] as? (any DynamicPhysicsBody) else {
                continue
            }
            applyFrameCollisionBetween(body, and: frame, delta: delta)
            for j in 0..<bodies.count where i != j {
                if let circleBody = bodies[j] as? (any CirclePhysicsBody) {
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

    private func applyFrameCollisionBetween<T: DynamicPhysicsBody>(_ body: T,
                                                                   and frame: CGSize,
                                                                   delta: TimeInterval) {
        let futureBody = body.clone()
        applyStep(body: futureBody, delta: delta)
        body.resolveCollisionWith(frame: frame, futureBody: futureBody)
    }

    private func applyCircleBodyCollisionBetween<T: DynamicPhysicsBody>(_ body: T,
                                                                        and circleBody: any CirclePhysicsBody,
                                                                        delta: TimeInterval) {
        let futureBody = body.clone()
        applyStep(body: futureBody, delta: delta)
        body.resolveCollisionWith(circleBody: circleBody, futureBody: futureBody)
    }
}
