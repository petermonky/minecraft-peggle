//
//  PegGameObjectTests.swift
//  PeggleTests
//
//  Created by Peter Jung on 2023/02/12.
//

import XCTest
@testable import Peggle

final class PegGameObjectTests: XCTestCase {

    func testConstruct_emptyParameters() {
        let shape = CirclePhysicsShape(radius: Constants.Peg.radius)
        let pegGameObject = PegGameObject()

        XCTAssertEqual(pegGameObject.position, CGPoint.zero,
                       "pegGameObject.position should be initialised to (0, 0).")
        XCTAssertFalse(pegGameObject.hasCollidedWithBall,
                       "pegGameObject.hasCollidedWithBall should be initialisd to false.")
        XCTAssertTrue(pegGameObject.isVisible,
                      "pegGameObject.isVisible should be initialised to true.")
        XCTAssertEqual(pegGameObject.shape, shape,
                       "pegGameObject.shape should be initialised to shape.")
        XCTAssertTrue(pegGameObject.peg is BluePeg,
                      "pegGameObject.shape should be initialised to blue peg.")
    }

    func testConstruct_nonEmptyParameters() {
        let shape = CirclePhysicsShape(radius: Constants.Peg.radius)
        let peg = RedPeg()
        let hasCollidedWithBall = true
        let pegGameObject = PegGameObject(peg: peg, hasCollidedWithBall: hasCollidedWithBall)

        XCTAssertEqual(pegGameObject.position, CGPoint.zero,
                       "pegGameObject.position should be initialised to (0, 0).")
        XCTAssertTrue(pegGameObject.hasCollidedWithBall,
                      "pegGameObject.hasCollidedWithBall should be initialisd to true.")
        XCTAssertTrue(pegGameObject.isVisible,
                      "pegGameObject.isVisible should be initialised to true.")
        XCTAssertEqual(pegGameObject.shape, shape,
                       "pegGameObject.shape should be initialised to shape.")
        XCTAssertEqual(pegGameObject.peg, peg,
                       "pegGameObject.shape should be initialised to blue peg.")
    }

    func testClone() {
        let peg = RedPeg()
        let hasCollidedWithBall = true
        let originalPegGameObject = PegGameObject(peg: peg, hasCollidedWithBall: hasCollidedWithBall)
        let clonedPegGameObject = originalPegGameObject.clone()

        XCTAssertEqual(originalPegGameObject.position, clonedPegGameObject.position,
                       "position should be equal between two objects.")
        XCTAssertEqual(originalPegGameObject.hasCollidedWithBall, clonedPegGameObject.hasCollidedWithBall,
                       "hasCollidedWithBall should be equal between two objects.")
        XCTAssertEqual(originalPegGameObject.isVisible, clonedPegGameObject.isVisible,
                       "isVisible should be equal between two objects.")
        XCTAssertEqual(originalPegGameObject.shape, clonedPegGameObject.shape,
                       "shape should be equal between two objects.")
        XCTAssertIdentical(originalPegGameObject.peg, clonedPegGameObject.peg,
                           "peg should be identical between two objects.")
    }

}
