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
        bodies = bodies.map { body in
            guard var body = body as? any DynamicBody else {
                return body
            }
            body = handleStep(body: body, delta: delta)
            body = handleCollisions(body: body, delta: delta)
            return body
        }
    }

    private func handleStep<T: DynamicBody>(body: T, delta: TimeInterval) -> T {
        var body = body
        body = handleGravity(body: body, delta: delta)
        body = handleVelocity(body: body, delta: delta)
        return body
    }

    private func handleGravity<T: DynamicBody>(body: T, delta: TimeInterval) -> T {
        var body = body
        let velocity = body.velocity.add(by: gravity.scale(by: delta))
        body.updateVelocity(velocity)
        return body
    }

    private func handleVelocity<T: DynamicBody>(body: T, delta: TimeInterval) -> T {
        var body = body
        let position = body.position.move(by: body.velocity.scale(by: delta))
        body.updatePosition(position)
        return body
    }

    private func handleCollisions<T: DynamicBody>(body: T, delta: TimeInterval) -> T {
        var body = body
        let futureBody = handleStep(body: body, delta: delta)
        body.resolveCollisionWith(frame: frame, futureBody: futureBody)
        
        bodies.filter{ $0 == body }
        
        circlePhysicsBodies.forEach { circleBody in
            if var body = body as? any CirclePhysicsBody, body == circleBody {
                print(123)
            } else {
                body.resolveCollisionWith(circleBody: circleBody, futureBody: futureBody)
            }
        }
        
        return body
    }
}
