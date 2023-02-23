//
//  CircleCircleCollisionDataTests.swift
//  PeggleTests
//
//  Created by Peter Jung on 2023/02/12.
//

import XCTest
@testable import Peggle

final class CircleCircleCollisionDataTests: XCTestCase {

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

    func testConstruct_dynamicCirclePhysicsBodyAndCirclePhysicsBody() {
        let first = TestDynamicCirclePhysicsBody()
        let second = TestCirclePhysicsBody()
        let collisionData = BodyBodyCollisionData(circle1: first, circle2: second)

        XCTAssertEqual(collisionData.sourceId, first.id,
                       "sourceId should be initialised to that of first body's ID.")
        XCTAssertEqual(collisionData.targetId, second.id,
                       "targetId should be initialised to that of second body's ID.")
    }

    func testConstruct_dynamicCirclePhysicsBodyAndDynamicCirclePhysicsBody() {
        let first = TestDynamicCirclePhysicsBody()
        let second = TestDynamicCirclePhysicsBody()
        let collisionData = BodyBodyCollisionData(circle1: first, circle2: second)

        XCTAssertEqual(collisionData.sourceId, first.id,
                       "sourceId should be initialised to that of first body's ID.")
        XCTAssertEqual(collisionData.targetId, second.id,
                       "targetId should be initialised to that of second body's ID.")
    }

}
