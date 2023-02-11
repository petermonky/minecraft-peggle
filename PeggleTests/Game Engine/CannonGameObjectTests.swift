//
//  CannonGameObjectTests.swift
//  PeggleTests
//
//  Created by Peter Jung on 2023/02/12.
//

import XCTest
@testable import Peggle

final class CannonGameObjectTests: XCTestCase {

    func testConstruct_emptyParameters() {
        let cannonGameObject = CannonGameObject()

        XCTAssertEqual(cannonGameObject.position, CGPoint.zero,
                       "cannonGameObject.position should be initialised to (0, 0).")
        XCTAssertEqual(cannonGameObject.angle, CGFloat.zero,
                       "cannonGameObject.angle should be initialised to 0.")
        XCTAssertTrue(cannonGameObject.isAvailable,
                      "cannonGameObject.isAvailable should be initialised to true.")
    }

    func testConstruct_nonEmptyParameters() {
        let position = CGPoint(x: 100, y: 100)
        let angle = CGFloat.pi
        let isAvailable = false
        let cannonGameObject = CannonGameObject(position: position, angle: angle, isAvailable: isAvailable)

        XCTAssertEqual(cannonGameObject.position, position,
                       "cannonGameObject.position should be initialised to (100, 100).")
        XCTAssertEqual(cannonGameObject.angle, angle,
                       "cannonGameObject.angle should be initialised to pi.")
        XCTAssertFalse(cannonGameObject.isAvailable,
                       "cannonGameObject.isAvailable should be initialised to false.")
    }

    func testSetAvailable_initiallyAvailable() {
        let cannonGameObject = CannonGameObject()

        cannonGameObject.setAvailable()
        XCTAssertTrue(cannonGameObject.isAvailable,
                      "cannonGameObject.isAvailable should be updated to true.")
    }

    func testSetAvailable_initiallyUnavailable() {
        let cannonGameObject = CannonGameObject(isAvailable: false)

        cannonGameObject.setAvailable()
        XCTAssertTrue(cannonGameObject.isAvailable,
                      "cannonGameObject.isAvailable should be updated to true.")
    }

    func testSetUnavailable_initiallyAvailable() {
        let cannonGameObject = CannonGameObject()

        cannonGameObject.setUnavailable()
        XCTAssertFalse(cannonGameObject.isAvailable,
                       "cannonGameObject.isAvailable should be updated to false.")
    }

    func testSetUnavailable_initiallyUnavailable() {
        let cannonGameObject = CannonGameObject(isAvailable: false)

        cannonGameObject.setUnavailable()
        XCTAssertFalse(cannonGameObject.isAvailable,
                       "cannonGameObject.isAvailable should be updated to false.")
    }

}
