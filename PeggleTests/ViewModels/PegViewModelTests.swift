//
//  PegViewModelTests.swift
//  PeggleTests
//
//  Created by Peter Jung on 2023/01/27.
//

import XCTest
@testable import Peggle

final class PegViewModelTests: XCTestCase {

    func testConstruct_emptyParameters() {
        let pegViewModel = PegViewModel()

        XCTAssertEqual(pegViewModel.dragOffset, CGSize.zero,
                       "Peg view model dragOffset should be zero.")
        XCTAssertEqual(pegViewModel.zIndex, 0,
                       "Peg view model zIndex should be zero.")
        XCTAssertNotNil(pegViewModel.peg.id,
                        "Peg view model peg id should be new UUID.")
        XCTAssertEqual(pegViewModel.peg.type, PegType.blue,
                       "Peg view model peg type should be blue.")
        XCTAssertEqual(pegViewModel.peg.position, CGPoint.zero,
                       "Peg view model peg position should be CGPoint.zero.")
        XCTAssertEqual(pegViewModel.peg.normalImageName, "peg-blue",
                       "Peg view model peg imageName should be \"peg-blue\".")
    }

    func testConstruct_nonEmptyParameters() {
        let pegPosition = CGPoint(x: 100, y: 100)
        let dragOffset = CGSize(width: 100, height: 100)
        let pegViewModel = PegViewModel(peg: RedPeg(position: pegPosition),
                                        dragOffset: dragOffset)

        XCTAssertEqual(pegViewModel.dragOffset, dragOffset,
                       "Peg view model dragOffset should be non-zero.")
        XCTAssertEqual(pegViewModel.zIndex, 0,
                       "Peg view model zIndex should be zero.")
        XCTAssertNotNil(pegViewModel.peg.id,
                        "Peg view model peg id should be new UUID.")
        XCTAssertEqual(pegViewModel.peg.type, PegType.red,
                       "Peg view model peg type should be orange.")
        XCTAssertEqual(pegViewModel.peg.position, pegPosition,
                       "Peg view model peg position should be (100, 100).")
        XCTAssertEqual(pegViewModel.peg.normalImageName, "peg-orange",
                       "Peg view model peg imageName should be \"peg-orange\".")
    }

    func testOverlapsWith_fullOverlappingPeg_hasOverlap() {
        let pegViewModel1 = PegViewModel(peg: BluePeg(position: CGPoint.zero))
        let pegViewModel2 = PegViewModel(peg: BluePeg(position: CGPoint(x: 0, y: 0)))

        XCTAssertTrue(pegViewModel1.overlapsWith(peg: pegViewModel2))
    }

    func testOverlapsWith_halfOverlappingPeg_hasOverlap() {
        let pegViewModel1 = PegViewModel(peg: BluePeg(position: CGPoint.zero))
        let pegViewModel2 = PegViewModel(peg: BluePeg(position: CGPoint(x: Constants.Peg.radius, y: 0)))

        XCTAssertTrue(pegViewModel1.overlapsWith(peg: pegViewModel2))
    }

    func testOverlapsWith_borderOverlappingPeg_hasOverlap() {
        let pegViewModel1 = PegViewModel(peg: BluePeg(position: CGPoint.zero))
        let pegViewModel2 = PegViewModel(peg: BluePeg(position: CGPoint(x: 2 * Constants.Peg.radius, y: 0)))

        XCTAssertTrue(pegViewModel1.overlapsWith(peg: pegViewModel2))
    }

    func testOverlapsWith_nonOverlappingPeg_hasNoOverlap() {
        let pegViewModel1 = PegViewModel(peg: BluePeg(position: CGPoint.zero))
        let pegViewModel2 = PegViewModel(peg: BluePeg(position: CGPoint(x: 2 * Constants.Peg.radius + 0.1, y: 0)))

        XCTAssertFalse(pegViewModel1.overlapsWith(peg: pegViewModel2))
    }

    func testTranslateBy_zeroXAndzeroY() {
        let initialX: Double = 0
        let initialY: Double = 0
        let pegViewModel = PegViewModel(peg: BluePeg(position: CGPoint(x: initialX, y: initialY)))

        pegViewModel.translateBy(CGSize.zero)
        XCTAssertEqual(pegViewModel.peg.position.x, initialX, "Peg X position should be zero.")
        XCTAssertEqual(pegViewModel.peg.position.x, initialX, "Peg Y position should be zero.")
    }

    func testTranslateBy_zeroXAndPositiveY() {
        let initialX: Double = 0
        let initialY: Double = 0
        let pegViewModel = PegViewModel(peg: BluePeg(position: CGPoint(x: initialX, y: initialY)))

        let yOffset: Double = 1
        pegViewModel.translateBy(CGSize(width: 0, height: yOffset))
        XCTAssertEqual(pegViewModel.peg.position.x, initialX, "Peg X position should be zero.")
        XCTAssertEqual(pegViewModel.peg.position.y, yOffset, "Peg Y position should be \(yOffset).")
    }

    func testTranslateBy_zeroXAndNegativeY() {
        let initialX: Double = 0
        let initialY: Double = 0
        let pegViewModel = PegViewModel(peg: BluePeg(position: CGPoint(x: initialX, y: initialY)))

        let yOffset: Double = -1
        pegViewModel.translateBy(CGSize(width: 0, height: yOffset))
        XCTAssertEqual(pegViewModel.peg.position.x, initialX, "Peg X position should be zero.")
        XCTAssertEqual(pegViewModel.peg.position.y, yOffset, "Peg Y position should be \(yOffset).")
    }

    func testTranslateBy_positiveXAndZeroY() {
        let initialX: Double = 0
        let initialY: Double = 0
        let pegViewModel = PegViewModel(peg: BluePeg(position: CGPoint(x: initialX, y: initialY)))

        let xOffset: Double = 1
        pegViewModel.translateBy(CGSize(width: xOffset, height: 0))
        XCTAssertEqual(pegViewModel.peg.position.x, xOffset, "Peg X position should be \(xOffset).")
        XCTAssertEqual(pegViewModel.peg.position.y, 0, "Peg Y position should be zero.")
    }

    func testTranslateBy_positiveXAndPositiveY() {
        let initialX: Double = 0
        let initialY: Double = 0
        let pegViewModel = PegViewModel(peg: BluePeg(position: CGPoint(x: initialX, y: initialY)))

        let xOffset: Double = 1
        let yOffset: Double = 1
        pegViewModel.translateBy(CGSize(width: xOffset, height: yOffset))
        XCTAssertEqual(pegViewModel.peg.position.x, xOffset, "Peg X position should be \(xOffset).")
        XCTAssertEqual(pegViewModel.peg.position.y, yOffset, "Peg Y position should be \(yOffset).")
    }

    func testTranslateBy_positiveXAndNegativeY() {
        let initialX: Double = 0
        let initialY: Double = 0
        let pegViewModel = PegViewModel(peg: BluePeg(position: CGPoint(x: initialX, y: initialY)))

        let xOffset: Double = 1
        let yOffset: Double = -1
        pegViewModel.translateBy(CGSize(width: xOffset, height: yOffset))
        XCTAssertEqual(pegViewModel.peg.position.x, xOffset, "Peg X position should be \(xOffset).")
        XCTAssertEqual(pegViewModel.peg.position.y, yOffset, "Peg Y position should be \(yOffset).")
    }

    func testTranslateBy_negativeXAndZeroY() {
        let initialX: Double = 0
        let initialY: Double = 0
        let pegViewModel = PegViewModel(peg: BluePeg(position: CGPoint(x: initialX, y: initialY)))

        let xOffset: Double = -1
        pegViewModel.translateBy(CGSize(width: xOffset, height: 0))
        XCTAssertEqual(pegViewModel.peg.position.x, xOffset, "Peg X position should be \(xOffset).")
        XCTAssertEqual(pegViewModel.peg.position.y, 0, "Peg Y position should be zero.")
    }

    func testTranslateBy_negativeXAndPositiveY() {
        let initialX: Double = 0
        let initialY: Double = 0
        let pegViewModel = PegViewModel(peg: BluePeg(position: CGPoint(x: initialX, y: initialY)))

        let xOffset: Double = -1
        let yOffset: Double = 1
        pegViewModel.translateBy(CGSize(width: xOffset, height: yOffset))
        XCTAssertEqual(pegViewModel.peg.position.x, xOffset, "Peg X position should be \(xOffset).")
        XCTAssertEqual(pegViewModel.peg.position.y, yOffset, "Peg Y position should be \(yOffset).")
    }

    func testTranslateBy_negativeXAndNegativeY() {
        let initialX: Double = 0
        let initialY: Double = 0
        let pegViewModel = PegViewModel(peg: BluePeg(position: CGPoint(x: initialX, y: initialY)))

        let xOffset: Double = -1
        let yOffset: Double = -1
        pegViewModel.translateBy(CGSize(width: xOffset, height: yOffset))
        XCTAssertEqual(pegViewModel.peg.position.x, xOffset, "Peg X position should be \(xOffset).")
        XCTAssertEqual(pegViewModel.peg.position.y, yOffset, "Peg Y position should be \(yOffset).")
    }

    func testClone_bluePeg() {
        let peg = BluePeg(position: CGPoint.zero)
        let pegViewModel = PegViewModel(peg: peg)
        let clone = pegViewModel.clone()

        XCTAssertNotEqual(pegViewModel, clone, "Peg should not be equal to clone.")
        XCTAssertNotEqual(pegViewModel.peg.id, clone.peg.id, "Peg id should not be equal to clone id.")
        XCTAssertEqual(pegViewModel.peg.type, clone.peg.type, "Peg type should be equal to clone type.")
        XCTAssertEqual(pegViewModel.peg.position, clone.peg.position,
                       "Peg position should be equal to clone position.")
        XCTAssertEqual(pegViewModel.peg.normalImageName, clone.peg.normalImageName,
                       "Peg imageName should be equal to clone position.")
    }

    func testClone_orangePeg() {
        let peg = RedPeg(position: CGPoint.zero)
        let pegViewModel = PegViewModel(peg: peg)
        let clone = pegViewModel.clone()

        XCTAssertNotEqual(pegViewModel, clone, "Peg should not be equal to clone.")
        XCTAssertNotEqual(pegViewModel.peg.id, clone.peg.id, "Peg id should not be equal to clone id.")
        XCTAssertEqual(pegViewModel.peg.type, clone.peg.type, "Peg type should be equal to clone type.")
        XCTAssertEqual(pegViewModel.peg.position, clone.peg.position,
                       "Peg position should be equal to clone position.")
        XCTAssertEqual(pegViewModel.peg.normalImageName, clone.peg.normalImageName,
                       "Peg imageName should be equal to clone position.")
    }

    func testEqual_samePeg_isEqual() {
        let pegViewModel1 = PegViewModel()
        let pegViewModel2 = pegViewModel1

        XCTAssertEqual(pegViewModel1, pegViewModel2, "Same pegs should be equal.")
    }

    func testEqual_differentPegAndSameParameters_isNotEqual() {
        let pegViewModel1 = PegViewModel()
        let pegViewModel2 = PegViewModel()

        XCTAssertNotEqual(pegViewModel1, pegViewModel2, "Different pegs with same parameters should not be equal.")
    }

    func testEqual_differentPegAndDifferentParameters_isNotEqual() {
        let pegViewModel1 = PegViewModel()
        let pegViewModel2 = PegViewModel(peg: BluePeg(position: CGPoint(x: 100, y: 100)))

        XCTAssertNotEqual(pegViewModel1, pegViewModel2, "Different pegs with different parameters should not be equal.")
    }

    func testHash_samePeg_hasSameHash() {
        let pegViewModel1 = PegViewModel()
        let pegViewModel2 = pegViewModel1

        XCTAssertEqual(pegViewModel1.hashValue, pegViewModel2.hashValue, "Same pegs should have same hash.")
    }

    func testHash_differentPegAndSameParameters_hasDifferentHash() throws {
        let pegViewModel1 = PegViewModel()
        let pegViewModel2 = PegViewModel()

        XCTAssertNotEqual(pegViewModel1.hashValue, pegViewModel2.hashValue,
                          "Different pegs with same parameters should have different hash.")
    }

    func testHash_differentPegAndDifferentParameters_hasDifferentHash() {
        let pegViewModel1 = PegViewModel()
        let pegViewModel2 = PegViewModel(peg: BluePeg(position: CGPoint(x: 100, y: 100)))

        XCTAssertNotEqual(pegViewModel1.hashValue, pegViewModel2.hashValue,
                          "Different pegs with different parameters should have different hash.")
    }

}
