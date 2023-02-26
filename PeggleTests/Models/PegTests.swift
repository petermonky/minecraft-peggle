//
//  PegTests.swift
//  PeggleTests
//
//  Created by Peter Jung on 2023/01/27.
//

import XCTest
@testable import Peggle

final class PegTests: XCTestCase {

    func testConstruct_bluePeg() {
        let peg = BluePeg(position: CGPoint.zero)

        XCTAssertNotNil(peg.id, "Peg id should be new UUID.")
        XCTAssertEqual(peg.type, PegType.blue, "Peg type should be blue.")
        XCTAssertEqual(peg.position, CGPoint.zero, "Peg position should be CGPoint.zero.")
        XCTAssertEqual(peg.normalImageName, "peg-blue", "Peg imageName should be \"peg-blue\".")
    }

    func testConstruct_redPeg() {
        let peg = RedPeg(position: CGPoint.zero)

        XCTAssertNotNil(peg.id, "Peg id should be new UUID.")
        XCTAssertEqual(peg.type, PegType.red, "Peg type should be red.")
        XCTAssertEqual(peg.position, CGPoint.zero, "Peg position should be CGPoint.zero.")
        XCTAssertEqual(peg.normalImageName, "peg-red", "Peg imageName should be \"peg-red\".")
    }

    func testTranslateBy_zeroXAndzeroY() {
        let initialX: Double = 0
        let initialY: Double = 0
        let peg = BluePeg(position: CGPoint(x: initialX, y: initialY))

        peg.translateBy(CGSize.zero)
        XCTAssertEqual(peg.position.x, initialX, "Peg X position should be zero.")
        XCTAssertEqual(peg.position.x, initialX, "Peg Y position should be zero.")
    }

    func testTranslateBy_zeroXAndPositiveY() {
        let initialX: Double = 0
        let initialY: Double = 0
        let peg = BluePeg(position: CGPoint(x: initialX, y: initialY))

        let yOffset: Double = 1
        peg.translateBy(CGSize(width: 0, height: yOffset))
        XCTAssertEqual(peg.position.x, initialX, "Peg X position should be zero.")
        XCTAssertEqual(peg.position.y, yOffset, "Peg Y position should be \(yOffset).")
    }

    func testTranslateBy_zeroXAndNegativeY() {
        let initialX: Double = 0
        let initialY: Double = 0
        let peg = BluePeg(position: CGPoint(x: initialX, y: initialY))

        let yOffset: Double = -1
        peg.translateBy(CGSize(width: 0, height: yOffset))
        XCTAssertEqual(peg.position.x, initialX, "Peg X position should be zero.")
        XCTAssertEqual(peg.position.y, yOffset, "Peg Y position should be \(yOffset).")
    }

    func testTranslateBy_positiveXAndZeroY() {
        let initialX: Double = 0
        let initialY: Double = 0
        let peg = BluePeg(position: CGPoint(x: initialX, y: initialY))

        let xOffset: Double = 1
        peg.translateBy(CGSize(width: xOffset, height: 0))
        XCTAssertEqual(peg.position.x, xOffset, "Peg X position should be \(xOffset).")
        XCTAssertEqual(peg.position.y, 0, "Peg Y position should be zero.")
    }

    func testTranslateBy_positiveXAndPositiveY() {
        let initialX: Double = 0
        let initialY: Double = 0
        let peg = BluePeg(position: CGPoint(x: initialX, y: initialY))

        let xOffset: Double = 1
        let yOffset: Double = 1
        peg.translateBy(CGSize(width: xOffset, height: yOffset))
        XCTAssertEqual(peg.position.x, xOffset, "Peg X position should be \(xOffset).")
        XCTAssertEqual(peg.position.y, yOffset, "Peg Y position should be \(yOffset).")
    }

    func testTranslateBy_positiveXAndNegativeY() {
        let initialX: Double = 0
        let initialY: Double = 0
        let peg = BluePeg(position: CGPoint(x: initialX, y: initialY))

        let xOffset: Double = 1
        let yOffset: Double = -1
        peg.translateBy(CGSize(width: xOffset, height: yOffset))
        XCTAssertEqual(peg.position.x, xOffset, "Peg X position should be \(xOffset).")
        XCTAssertEqual(peg.position.y, yOffset, "Peg Y position should be \(yOffset).")
    }

    func testTranslateBy_negativeXAndZeroY() {
        let initialX: Double = 0
        let initialY: Double = 0
        let peg = BluePeg(position: CGPoint(x: initialX, y: initialY))

        let xOffset: Double = -1
        peg.translateBy(CGSize(width: xOffset, height: 0))
        XCTAssertEqual(peg.position.x, xOffset, "Peg X position should be \(xOffset).")
        XCTAssertEqual(peg.position.y, 0, "Peg Y position should be zero.")
    }

    func testTranslateBy_negativeXAndPositiveY() {
        let initialX: Double = 0
        let initialY: Double = 0
        let peg = BluePeg(position: CGPoint(x: initialX, y: initialY))

        let xOffset: Double = -1
        let yOffset: Double = 1
        peg.translateBy(CGSize(width: xOffset, height: yOffset))
        XCTAssertEqual(peg.position.x, xOffset, "Peg X position should be \(xOffset).")
        XCTAssertEqual(peg.position.y, yOffset, "Peg Y position should be \(yOffset).")
    }

    func testTranslateBy_negativeXAndNegativeY() {
        let initialX: Double = 0
        let initialY: Double = 0
        let peg = BluePeg(position: CGPoint(x: initialX, y: initialY))

        let xOffset: Double = -1
        let yOffset: Double = -1
        peg.translateBy(CGSize(width: xOffset, height: yOffset))
        XCTAssertEqual(peg.position.x, xOffset, "Peg X position should be \(xOffset).")
        XCTAssertEqual(peg.position.y, yOffset, "Peg Y position should be \(yOffset).")
    }

    func testClone_bluePeg() {
        let peg = BluePeg(position: CGPoint.zero)
        let clone = peg.clone()

        XCTAssertNotEqual(peg, clone, "Peg should not be equal to clone.")
        XCTAssertNotEqual(peg.id, clone.id, "Peg id should not be equal to clone id.")
        XCTAssertEqual(peg.type, clone.type, "Peg type should be equal to clone type.")
        XCTAssertEqual(peg.position, clone.position, "Peg position should be equal to clone position.")
        XCTAssertEqual(peg.normalImageName, clone.normalImageName, "Peg imageName should be equal to clone position.")
    }

    func testClone_redPeg() {
        let peg = RedPeg(position: CGPoint.zero)
        let clone = peg.clone()

        XCTAssertNotEqual(peg, clone, "Peg should not be equal to clone.")
        XCTAssertNotEqual(peg.id, clone.id, "Peg id should not be equal to clone id.")
        XCTAssertEqual(peg.type, clone.type, "Peg type should be equal to clone type.")
        XCTAssertEqual(peg.position, clone.position, "Peg position should be equal to clone position.")
        XCTAssertEqual(peg.normalImageName, clone.normalImageName, "Peg imageName should be equal to clone position.")
    }

    func testEqual_samePeg_isEqual() {
        let peg1 = BluePeg()
        let peg2 = peg1

        XCTAssertEqual(peg1, peg2, "Same pegs should be equal.")
    }

    func testEqual_differentPegAndSameParameters_isNotEqual() {
        let peg1 = BluePeg()
        let peg2 = BluePeg()

        XCTAssertNotEqual(peg1, peg2, "Different pegs with same parameters should not be equal.")
    }

    func testEqual_differentPegAndDifferentParameters_isNotEqual() {
        let peg1 = BluePeg()
        let peg2 = BluePeg(position: CGPoint(x: 100, y: 100))

        XCTAssertNotEqual(peg1, peg2, "Different pegs with different parameters should not be equal.")
    }

    func testHash_samePeg_hasSameHash() {
        let peg1 = BluePeg()
        let peg2 = peg1

        XCTAssertEqual(peg1.hashValue, peg2.hashValue, "Same pegs should have same hash.")
    }

    func testHash_differentPegAndSameParameters_hasDifferentHash() throws {
        let peg1 = BluePeg()
        let peg2 = BluePeg()

        XCTAssertNotEqual(peg1.hashValue, peg2.hashValue,
                          "Different pegs with same parameters should have different hash.")
    }

    func testHash_differentPegAndDifferentParameters_hasDifferentHash() {
        let peg1 = BluePeg()
        let peg2 = BluePeg(position: CGPoint(x: 100, y: 100))

        XCTAssertNotEqual(peg1.hashValue, peg2.hashValue,
                          "Different pegs with different parameters should have different hash.")
    }

}
