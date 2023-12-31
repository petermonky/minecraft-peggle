//
//  LevelTests.swift
//  PeggleTests
//
//  Created by Peter Jung on 2023/01/27.
//

import XCTest
@testable import Peggle

final class LevelTests: XCTestCase {

    func testConstruct_emptyParameters() {
        let level = Level()

        XCTAssertNotNil(level.id)
        XCTAssertEqual(level.frame, Frame())
        XCTAssertEqual(level.title, "")
        XCTAssertNotNil(level.updatedAt)
        XCTAssertEqual(level.pegs, [])
        XCTAssertEqual(level.blocks, [])
    }

    func testConstruct_filledParameters() {
        let id = UUID()
        let frame = Frame(size: CGSize(width: 100, height: 100))
        let title = "Monkey level 🐵"
        let updatedAt = Date.now
        let pegs = Set<Peg>([BluePeg(), RedPeg()])
        let blocks = Set<Block>([NormalBlock(), NormalBlock()])
        let level = Level(id: id, frame: frame, title: title, updatedAt: updatedAt, pegs: pegs, blocks: blocks)

        XCTAssertEqual(level.id, id)
        XCTAssertEqual(level.frame, frame)
        XCTAssertEqual(level.title, title)
        XCTAssertEqual(level.updatedAt, updatedAt)
        XCTAssertEqual(level.blocks, blocks)
        XCTAssertEqual(level.pegs, pegs)
    }

    func testEqual_sameIdAndSameParameters_isEqual() {
        let id = UUID()
        let title = "Monkey level 🐵"
        let updatedAt = Date.now
        let pegs = Set<Peg>([BluePeg(), RedPeg()])
        let level1 = Level(id: id, title: title, updatedAt: updatedAt, pegs: pegs)
        let level2 = Level(id: id, title: title, updatedAt: updatedAt, pegs: pegs)

        XCTAssertEqual(level1, level2, "Levels with same id and same parameters should be equal.")
    }

    func testEqual_sameIdAndDifferentParameters_isEqual() {
        let id = UUID()
        let title1 = "Monkey level 🐵"
        let updatedAt1 = Date.now
        let pegs1 = Set<Peg>([BluePeg(), RedPeg()])
        let level1 = Level(id: id, title: title1, updatedAt: updatedAt1, pegs: pegs1)
        let title2 = "Cat level 🐱"
        let updatedAt2 = Date.now
        let pegs2 = Set<Peg>([])
        let level2 = Level(id: id, title: title2, updatedAt: updatedAt2, pegs: pegs2)

        XCTAssertEqual(level1, level2, "Levels with same id and different parameters should be equal.")
    }

    func testEqual_differentIdAndSameParameters_isNotEqual() {
        let id1 = UUID()
        let id2 = UUID()
        let title = "Monkey level 🐵"
        let updatedAt = Date.now
        let pegs = Set<Peg>([BluePeg(), RedPeg()])
        let level1 = Level(id: id1, title: title, updatedAt: updatedAt, pegs: pegs)
        let level2 = Level(id: id2, title: title, updatedAt: updatedAt, pegs: pegs)

        XCTAssertNotEqual(level1, level2, "Levels with different id and same parameters should not be equal.")
    }

    func testEqual_differentIdAndDifferentParameters_isNotEqual() {
        let id1 = UUID()
        let title1 = "Monkey level 🐵"
        let updatedAt1 = Date.now
        let pegs1 = Set<Peg>([BluePeg(), RedPeg()])
        let level1 = Level(id: id1, title: title1, updatedAt: updatedAt1, pegs: pegs1)
        let id2 = UUID()
        let title2 = "Cat level 🐱"
        let updatedAt2 = Date.now
        let pegs2 = Set<Peg>([])
        let level2 = Level(id: id2, title: title2, updatedAt: updatedAt2, pegs: pegs2)

        XCTAssertNotEqual(level1, level2, "Levels with different id and different parameters should not be equal.")
    }

    func testHash_sameIdAndSameParameters_hasSameHash() {
        let id = UUID()
        let title = "Monkey level 🐵"
        let updatedAt = Date.now
        let pegs = Set<Peg>([BluePeg(), RedPeg()])
        let level1 = Level(id: id, title: title, updatedAt: updatedAt, pegs: pegs)
        let level2 = Level(id: id, title: title, updatedAt: updatedAt, pegs: pegs)

        XCTAssertEqual(level1.hashValue, level2.hashValue,
                       "Levels with same id and same parameters should have same hash.")
    }

    func testHash_sameIdAndDifferentParameters_hasSameHash() {
        let id = UUID()
        let title1 = "Monkey level 🐵"
        let updatedAt1 = Date.now
        let pegs1 = Set<Peg>([BluePeg(), RedPeg()])
        let level1 = Level(id: id, title: title1, updatedAt: updatedAt1, pegs: pegs1)
        let title2 = "Cat level 🐱"
        let updatedAt2 = Date.now
        let pegs2 = Set<Peg>([])
        let level2 = Level(id: id, title: title2, updatedAt: updatedAt2, pegs: pegs2)

        XCTAssertEqual(level1.hashValue, level2.hashValue,
                       "Levels with same id and different parameters should have same hash.")
    }

    func testHash_differentIdAndSameParameters_hasDifferentHash() {
        let id1 = UUID()
        let id2 = UUID()
        let title = "Monkey level 🐵"
        let updatedAt = Date.now
        let pegs = Set<Peg>([BluePeg(), RedPeg()])
        let level1 = Level(id: id1, title: title, updatedAt: updatedAt, pegs: pegs)
        let level2 = Level(id: id2, title: title, updatedAt: updatedAt, pegs: pegs)

        XCTAssertNotEqual(level1.hashValue, level2.hashValue,
                          "Levels with different id and same parameters should have different hash.")
    }

    func testHash_differentIdAndDifferentParameters_hasDifferentHash() {
        let id1 = UUID()
        let title1 = "Monkey level 🐵"
        let updatedAt1 = Date.now
        let pegs1 = Set<Peg>([BluePeg(), RedPeg()])
        let level1 = Level(id: id1, title: title1, updatedAt: updatedAt1, pegs: pegs1)
        let id2 = UUID()
        let title2 = "Cat level 🐱"
        let updatedAt2 = Date.now
        let pegs2 = Set<Peg>([])
        let level2 = Level(id: id2, title: title2, updatedAt: updatedAt2, pegs: pegs2)

        XCTAssertNotEqual(level1.hashValue, level2.hashValue,
                          "Levels with different id and different parameters should have different hash.")
    }

}
