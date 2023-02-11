//
//  CircleFrameCollisionDataTests.swift
//  PeggleTests
//
//  Created by Peter Jung on 2023/02/12.
//

import XCTest
@testable import Peggle

final class CircleFrameCollisionDataTests: XCTestCase {

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

    func testConstruct_dynamicCirclePhysicsBodyAndBottomFrameSIde() {
        let circleBody = TestDynamicCirclePhysicsBody()
        let side: FrameSide = .bottom
        let collisionData = CircleFrameCollisionData(circleBody: circleBody, side: side)

        XCTAssertEqual(collisionData.sourceId, circleBody.id,
                       "sourceId should be equal to that of circle body's ID.")
        XCTAssertEqual(collisionData.side, side,
                       "side should be equal to bottom frame side.")
    }

    func testConstruct_dynamicCirclePhysicsBodyAndTopFrameSIde() {
        let circleBody = TestDynamicCirclePhysicsBody()
        let side: FrameSide = .top
        let collisionData = CircleFrameCollisionData(circleBody: circleBody, side: side)

        XCTAssertEqual(collisionData.sourceId, circleBody.id,
                       "sourceId should be equal to that of circle body's ID.")
        XCTAssertEqual(collisionData.side, side,
                       "side should be equal to top frame side.")
    }

    func testConstruct_dynamicCirclePhysicsBodyAndLeftFrameSIde() {
        let circleBody = TestDynamicCirclePhysicsBody()
        let side: FrameSide = .left
        let collisionData = CircleFrameCollisionData(circleBody: circleBody, side: side)

        XCTAssertEqual(collisionData.sourceId, circleBody.id,
                       "sourceId should be equal to that of circle body's ID.")
        XCTAssertEqual(collisionData.side, side,
                       "side should be equal to left frame side.")
    }

    func testConstruct_dynamicCirclePhysicsBodyAndRightFrameSIde() {
        let circleBody = TestDynamicCirclePhysicsBody()
        let side: FrameSide = .right
        let collisionData = CircleFrameCollisionData(circleBody: circleBody, side: side)

        XCTAssertEqual(collisionData.sourceId, circleBody.id,
                       "sourceId should be equal to that of circle body's ID.")
        XCTAssertEqual(collisionData.side, side,
                       "side should be equal to right frame side.")
    }

}
