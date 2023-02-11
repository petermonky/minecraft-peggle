//
//  BallGameObjectTests.swift
//  PeggleTests
//
//  Created by Peter Jung on 2023/02/12.
//

import XCTest
@testable import Peggle

final class BallGameObjectTests: XCTestCase {

    func testConstruct_emptyParameters() {
        let shape = CirclePhysicsShape(radius: Constants.Ball.radius)
        let ballGameObject = BallGameObject()

        XCTAssertEqual(ballGameObject.position, CGPoint.zero,
                       "ballGameObject.position should be initialised to (0, 0).")
        XCTAssertEqual(ballGameObject.velocity, CGVector.zero,
                       "ballGameObject.velocity should be initialisd to (0, 0).")
        XCTAssertEqual(ballGameObject.shape, shape,
                       "pegGameObject.shape should be initialised to shape.")
    }

    func testConstruct_nonEmptyParameters() {
        let shape = CirclePhysicsShape(radius: Constants.Ball.radius)
        let position = CGPoint(x: 100, y: 100)
        let velocity = CGVector(dx: 100, dy: 100)
        let ballGameObject = BallGameObject(position: position, velocity: velocity)

        XCTAssertEqual(ballGameObject.position, position,
                       "ballGameObject.position should be initialised to (100, 100).")
        XCTAssertEqual(ballGameObject.velocity, velocity,
                       "ballGameObject.velocity should be initialisd to (100, 100).")
        XCTAssertEqual(ballGameObject.shape, shape,
                       "pegGameObject.shape should be initialised to shape.")
    }

    func testClone() {
        let position = CGPoint(x: 100, y: 100)
        let velocity = CGVector(dx: 100, dy: 100)
        let originalBallGameObject = BallGameObject(position: position, velocity: velocity)
        let clonedBallGameObject = originalBallGameObject.clone()

        XCTAssertEqual(originalBallGameObject.position, clonedBallGameObject.position,
                       "position should be equal between two objects.")
        XCTAssertEqual(originalBallGameObject.velocity, clonedBallGameObject.velocity,
                       "velocity should be equal between two objects.")
        XCTAssertEqual(originalBallGameObject.shape, clonedBallGameObject.shape,
                       "shape should be equal between two objects.")
    }

}
