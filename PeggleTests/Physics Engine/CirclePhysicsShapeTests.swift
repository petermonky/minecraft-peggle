//
//  CirclePhysicsShapeTests.swift
//  PeggleTests
//
//  Created by Peter Jung on 2023/02/11.
//

import XCTest
@testable import Peggle

final class CirclePhysicsShapeTests: XCTestCase {

    func testConstruct_emptyParameters() {
        let circlePhysicsShape = CirclePhysicsShape()

        XCTAssertEqual(circlePhysicsShape.center, CGPoint.zero,
                       "circlePhysicsShape center should be at (0, 0).")
        XCTAssertEqual(circlePhysicsShape.radius, 1,
                       "circlePhysicsShape radius should be equal to 1.")
    }

    func testConstruct_nonEmptyParametersAndPositiveRadius() {
        let radius = 100.0
        let circlePhysicsShape = CirclePhysicsShape(radius: radius)

        XCTAssertEqual(circlePhysicsShape.center, CGPoint.zero,
                       "circlePhysicsShape center should be at (0, 0).")
        XCTAssertEqual(circlePhysicsShape.radius, 100,
                       "circlePhysicsShape radius should be equal to 100.")
    }

    func testConstruct_nonEmptyParametersAndZeroRadius() {
        let radius = 0.0
        let circlePhysicsShape = CirclePhysicsShape(radius: radius)

        XCTAssertEqual(circlePhysicsShape.center, CGPoint.zero,
                       "circlePhysicsShape center should be at (0, 0).")
        XCTAssertEqual(circlePhysicsShape.radius, 1,
                       "circlePhysicsShape radius should be equal to 1.")
    }

    func testConstruct_nonEmptyParametersAndNegativeRadius() {
        let radius = -100.0
        let circlePhysicsShape = CirclePhysicsShape(radius: radius)

        XCTAssertEqual(circlePhysicsShape.center, CGPoint.zero,
                       "circlePhysicsShape center should be at (0, 0).")
        XCTAssertEqual(circlePhysicsShape.radius, 1,
                       "circlePhysicsShape radius should be equal to 1.")
    }

}
