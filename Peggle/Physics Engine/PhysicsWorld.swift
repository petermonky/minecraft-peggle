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
        bodies = bodies.map { body in
            guard var body = body as? any DynamicPhysicsBody else {
                return body
            }
            body = applyStep(body: body, delta: delta)
            return body
        }
    }

    private func handleCollisions(delta: TimeInterval) {
        var copy = bodies
        for i in 0..<bodies.count {
            guard var body = bodies[i] as? (any DynamicPhysicsBody) else {
                continue
            }
            body = applyFrameCollisionBetween(body, and: frame, delta: delta)
            for j in i + 1..<bodies.count {
                if let circleBody = bodies[j] as? (any CirclePhysicsBody) {
                    body = applyCircleBodyCollisionBetween(body, and: circleBody, delta: delta)
                } // TODO: else if polygon
            }
            copy[i] = body
        }
        bodies = copy
    }

    private func applyStep<T: DynamicPhysicsBody>(body: T, delta: TimeInterval) -> T {
        var body = body
        body = applyGravity(body: body, delta: delta)
        body = applyVelocity(body: body, delta: delta)
        return body
    }

    private func applyGravity<T: DynamicPhysicsBody>(body: T, delta: TimeInterval) -> T {
        var body = body
        let velocity = body.velocity.add(by: gravity.scale(by: delta))
        body.updateVelocity(velocity)
        return body
    }

    private func applyVelocity<T: DynamicPhysicsBody>(body: T, delta: TimeInterval) -> T {
        var body = body
        let position = body.position.move(by: body.velocity.scale(by: delta))
        body.updatePosition(position)
        return body
    }

    private func applyFrameCollisionBetween<T: DynamicPhysicsBody>(_ body: T,
                                                                   and frame: CGSize,
                                                                   delta: TimeInterval) -> T {
        var body = body
        let futureBody = applyStep(body: body, delta: delta)
        body.resolveCollisionWith(frame: frame, futureBody: futureBody)
        return body
    }

    private func applyCircleBodyCollisionBetween<T: DynamicPhysicsBody>(_ body: T,
                                                                        and circleBody: any CirclePhysicsBody,
                                                                        delta: TimeInterval) -> T {
        var body = body
        let futureBody = applyStep(body: body, delta: delta)
        body.resolveCollisionWith(circleBody: circleBody, futureBody: futureBody)
        return body
    }
}
