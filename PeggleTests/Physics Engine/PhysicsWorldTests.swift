//
//  PhysicsWorldTests.swift
//  PeggleTests
//
//  Created by Peter Jung on 2023/02/12.
//

import XCTest
@testable import Peggle

final class PhysicsWorldTests: XCTestCase {

    private final class TestDynamicCirclePhysicsBody: DynamicCirclePhysicsBody {
        var position: CGPoint
        var velocity: CGVector
        let shape: CirclePhysicsShape

        init(
            position: CGPoint = CGPoint.zero,
            velocity: CGVector = CGVector.zero,
            shape: CirclePhysicsShape = CirclePhysicsShape()
        ) {
            self.position = position
            self.velocity = velocity
            self.shape = shape
        }

        func clone() -> TestDynamicCirclePhysicsBody {
            TestDynamicCirclePhysicsBody(position: position, velocity: velocity, shape: shape)
        }
    }

    private final class TestCirclePhysicsBody: CirclePhysicsBody {
        var position: CGPoint
        let shape: CirclePhysicsShape

        init(position: CGPoint = CGPoint.zero, shape: CirclePhysicsShape = CirclePhysicsShape()) {
            self.position = position
            self.shape = shape
        }

        func clone() -> TestCirclePhysicsBody {
            TestCirclePhysicsBody(position: position, shape: shape)
        }
    }

    func testConstruct_emptyParameters() {
        let physicsWorld = PhysicsWorld()

        XCTAssertEqual(physicsWorld.frame, CGSize.zero,
                       "Physics world frame should be initialised to CGSize.zero.")
        XCTAssertEqual(physicsWorld.gravity, Constants.Physics.gravity,
                       "Physics world gravity should be initialised to default gravity.")
        XCTAssertTrue(physicsWorld.bodies.isEmpty,
                      "Physics world bodies should be initialised to empty array.")
        XCTAssertTrue(physicsWorld.collisionData.isEmpty,
                      "Physics world collisionData should be initialised to empty array.")
    }

    func testConstruct_nonEmptyParameters() {
        let frame = CGSize(width: 100, height: 100)
        let gravity = CGVector(dx: 200, dy: 200)
        let body1 = TestDynamicCirclePhysicsBody()
        let body2 = TestCirclePhysicsBody()
        let bodies: [any PhysicsBody] = [body1, body2]
        let data = CircleCircleCollisionData(first: body1, second: body2)
        let collisionData: [any CollisionData] = [data]
        let physicsWorld = PhysicsWorld(frame: frame, gravity: gravity, bodies: bodies, collisionData: collisionData)

        XCTAssertEqual(physicsWorld.frame, frame,
                       "Physics world frame should be initialised to CGSize.zero.")
        XCTAssertEqual(physicsWorld.gravity, gravity,
                       "Physics world gravity should be initialised to default gravity.")
        for (body1, body2) in zip(bodies, physicsWorld.bodies) {
            XCTAssertIdentical(body1, body2,
                               "Bodies should be identical.")
        }
        for (data1, data2) in zip(collisionData, physicsWorld.collisionData) {
            XCTAssertEqual(data1.hashValue, data2.hashValue,
                           "Hash values should be equal.")
        }
    }

    func testCircleBodies_hasNoCircleBodies() {
        let physicsWorld = PhysicsWorld()

        XCTAssertTrue(physicsWorld.circlePhysicsBodies.isEmpty,
                      "Physics world circle bodies should be initialised to empty array.")
    }

    func testCircleBodies_hasCircleBodies() {
        let body1 = TestDynamicCirclePhysicsBody()
        let body2 = TestCirclePhysicsBody()
        let bodies: [any PhysicsBody] = [body1, body2]
        let physicsWorld = PhysicsWorld(bodies: bodies)

        for (body1, body2) in zip(bodies, physicsWorld.circlePhysicsBodies) {
            XCTAssertIdentical(body1, body2,
                               "Bodies should be identical.")
        }
    }

    func testAddBody_emptyBodies() {
        let physicsWorld = PhysicsWorld()

        let circleBody = TestCirclePhysicsBody()
        let expectedBodies = [circleBody]
        physicsWorld.addBody(circleBody)
        for (body1, body2) in zip(expectedBodies, physicsWorld.bodies) {
            XCTAssertIdentical(body1, body2,
                               "Bodies should be identical.")
        }
    }

    func testAddBody_nonEmptyBodies() {
        let body1 = TestDynamicCirclePhysicsBody()
        let body2 = TestCirclePhysicsBody()
        let bodies: [any PhysicsBody] = [body1, body2]
        let physicsWorld = PhysicsWorld(bodies: bodies)

        let circleBody = TestCirclePhysicsBody()
        let expectedBodies = bodies + [circleBody]
        physicsWorld.addBody(circleBody)
        for (body1, body2) in zip(expectedBodies, physicsWorld.bodies) {
            XCTAssertIdentical(body1, body2,
                               "Bodies should be identical.")
        }
    }

    func testRemoveBody_emptyBodies() {
        let physicsWorld = PhysicsWorld()

        let circleBody = TestCirclePhysicsBody()
        let expectedBodies: [any PhysicsBody] = []
        physicsWorld.removeBody(circleBody)
        for (body1, body2) in zip(expectedBodies, physicsWorld.bodies) {
            XCTAssertIdentical(body1, body2,
                               "Bodies should be identical.")
        }
    }

    func testRemoveBody_nonEmptyBodiesAndRemovingExistingBody() {
        let body1 = TestDynamicCirclePhysicsBody()
        let body2 = TestCirclePhysicsBody()
        let bodies: [any PhysicsBody] = [body1, body2]
        let physicsWorld = PhysicsWorld(bodies: bodies)

        let expectedBodies: [any PhysicsBody] = [body2]
        physicsWorld.removeBody(body1)
        for (body1, body2) in zip(expectedBodies, physicsWorld.bodies) {
            XCTAssertIdentical(body1, body2,
                               "Bodies should be identical.")
        }
    }

    func testRemoveBody_nonEmptyBodiesAndRemovingNonExistingBody() {
        let body1 = TestDynamicCirclePhysicsBody()
        let body2 = TestCirclePhysicsBody()
        let bodies: [any PhysicsBody] = [body1, body2]
        let physicsWorld = PhysicsWorld(bodies: bodies)

        let circleBody = TestCirclePhysicsBody()
        let expectedBodies: [any PhysicsBody] = [body1, body2]
        physicsWorld.removeBody(circleBody)
        for (body1, body2) in zip(expectedBodies, physicsWorld.bodies) {
            XCTAssertIdentical(body1, body2,
                               "Bodies should be identical.")
        }
    }

    func testUpdate_nonDynamicBodies() {
        let frame = CGSize(width: 1_000, height: 1_000)
        let gravity = CGVector(dx: 0, dy: 100)
        let body1 = TestCirclePhysicsBody(position: CGPoint(x: 100, y: 100), shape: CirclePhysicsShape(radius: 50))
        let body2 = TestCirclePhysicsBody(position: CGPoint(x: 200, y: 200), shape: CirclePhysicsShape(radius: 50))
        let bodies: [any PhysicsBody] = [body1, body2]
        let physicsWorld = PhysicsWorld(frame: frame, gravity: gravity, bodies: bodies)
        let delta: TimeInterval = 0.1

        let expectedBody1 = TestCirclePhysicsBody(position: CGPoint(x: 100, y: 100),
                                                  shape: CirclePhysicsShape(radius: 50))
        let expectedBody2 = TestCirclePhysicsBody(position: CGPoint(x: 200, y: 200),
                                                  shape: CirclePhysicsShape(radius: 50))
        let expectedBodies: [any PhysicsBody] = [expectedBody1, expectedBody2]
        physicsWorld.update(delta: delta)
        for (body1, body2) in zip(expectedBodies, physicsWorld.bodies) {
            guard let body1 = body1 as? any CirclePhysicsBody,
                  let body2 = body2 as? any CirclePhysicsBody else {
                XCTFail("Body types not set correctly")
                return
            }
            XCTAssertEqual(body1.position, body2.position,
                           "Body position should be equal.")
        }
    }

    func testUpdate_hasNoCollision() {
        let frame = CGSize(width: 1_000, height: 1_000)
        let gravity = CGVector(dx: 0, dy: 100)
        let body1 = TestCirclePhysicsBody(position: CGPoint(x: 100, y: 100),
                                          shape: CirclePhysicsShape(radius: 50))
        let body2 = TestDynamicCirclePhysicsBody(position: CGPoint(x: 200, y: 200),
                                                 shape: CirclePhysicsShape(radius: 50))
        let bodies: [any PhysicsBody] = [body1, body2]
        let physicsWorld = PhysicsWorld(frame: frame, gravity: gravity, bodies: bodies)
        let delta: TimeInterval = 0.1

        let expectedBody1 = TestCirclePhysicsBody(
            position: CGPoint(x: 100, y: 100),
            shape: CirclePhysicsShape(radius: 50)
        )
        let expectedBody2 = TestDynamicCirclePhysicsBody(
            position: CGPoint(x: 200, y: 200).move(by: gravity.scale(by: delta).scale(by: delta)),
            shape: CirclePhysicsShape(radius: 50)
        )
        let expectedBodies: [any PhysicsBody] = [expectedBody1, expectedBody2]
        physicsWorld.update(delta: delta)
        for (body1, body2) in zip(expectedBodies, physicsWorld.bodies) {
            guard let body1 = body1 as? any CirclePhysicsBody,
                  let body2 = body2 as? any CirclePhysicsBody else {
                XCTFail("Body types not set correctly.")
                return
            }
            XCTAssertEqual(body1.position, body2.position,
                           "Body position should be equal.")
        }
    }

    func testUpdate_hasCircleBodyToCircleBodyCollision() {
        let frame = CGSize(width: 1_000, height: 1_000)
        let gravity = CGVector(dx: 0, dy: 100)
        let body1 = TestCirclePhysicsBody(position: CGPoint(x: 100, y: 100),
                                          shape: CirclePhysicsShape(radius: 50))
        let body2 = TestDynamicCirclePhysicsBody(position: CGPoint(x: 200, y: 100),
                                                 velocity: CGVector(dx: -100, dy: 0),
                                                 shape: CirclePhysicsShape(radius: 50))
        let bodies: [any PhysicsBody] = [body1, body2]
        let physicsWorld = PhysicsWorld(frame: frame, gravity: gravity, bodies: bodies)
        let delta: TimeInterval = 0.1

        let expectedBody1 = TestCirclePhysicsBody(
            position: CGPoint(x: 100, y: 100),
            shape: CirclePhysicsShape(radius: 50)
        )
        let newPosition = CGPoint(x: 200, y: 100)
                              .move(by: gravity.scale(by: delta).scale(by: delta))
                              .move(by: CGVector(dx: -100, dy: 0).scale(by: -1 * delta * Constants.Physics.restitution))
        let expectedBody2 = TestDynamicCirclePhysicsBody(
            position: newPosition,
            shape: CirclePhysicsShape(radius: 50)
        )
        let expectedBodies: [any PhysicsBody] = [expectedBody1, expectedBody2]
        physicsWorld.update(delta: delta)
        for (body1, body2) in zip(expectedBodies, physicsWorld.bodies) {
            guard let body1 = body1 as? any CirclePhysicsBody,
                  let body2 = body2 as? any CirclePhysicsBody else {
                XCTFail("Body types not set correctly.")
                return
            }
            XCTAssertEqual(body1.position, body2.position,
                           "Body position should be equal.")
        }
    }

    func testUpdate_hasCircleBodyToFrameCollision() {
        let frame = CGSize(width: 1_000, height: 1_000)
        let gravity = CGVector(dx: 0, dy: 100)
        let body = TestDynamicCirclePhysicsBody(position: CGPoint(x: 100, y: 950),
                                                velocity: CGVector(dx: 0, dy: 100),
                                                shape: CirclePhysicsShape(radius: 50))
        let bodies: [any PhysicsBody] = [body]
        let physicsWorld = PhysicsWorld(frame: frame, gravity: gravity, bodies: bodies)
        let delta: TimeInterval = 0.1

        let newPosition = CGPoint(x: 100, y: 950)
                              .move(by: gravity.scale(by: delta).scale(by: delta))
                              .move(by: CGVector(dx: 0, dy: 100).scale(by: -1 * delta * Constants.Physics.restitution))
        let expectedBody = TestDynamicCirclePhysicsBody(
            position: newPosition,
            shape: CirclePhysicsShape(radius: 50)
        )
        let expectedBodies: [any PhysicsBody] = [expectedBody]
        physicsWorld.update(delta: delta)
        for (body1, body2) in zip(expectedBodies, physicsWorld.bodies) {
            guard let body1 = body1 as? any CirclePhysicsBody,
                  let body2 = body2 as? any CirclePhysicsBody else {
                XCTFail("Body types not set correctly.")
                return
            }
            XCTAssertEqual(body1.position, body2.position,
                           "Body position should be equal.")
        }
    }

}
