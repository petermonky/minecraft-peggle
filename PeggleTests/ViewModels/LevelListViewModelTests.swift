//
//  LevelListViewModelTests.swift
//  PeggleTests
//
//  Created by Peter Jung on 2023/01/27.
//

import XCTest
@testable import Peggle

final class LevelListViewModelTests: XCTestCase {

    func testConstruct_emptyParameters() {
        let levelList = LevelListViewModel()

        XCTAssertEqual(levelList.levels, [], "Level list should be initialised with empty set of levels.")
    }

    func testConstruct_filledParameters() {
        let levels = Set<Level>([Level(id: nil), Level(id: nil)])
        let levelList = LevelListViewModel(levels: levels)

        XCTAssertEqual(levelList.levels, levels, "Level list should be initialised with filled set of levels.")
    }

    func testLevelArray_emptyLevelSet() {
        let levelList = LevelListViewModel()

        XCTAssertEqual(levelList.levelArray, [],
                       "Level list with empty level set should return empty level array.")
    }

    func testLevelArray_filledLevelSet() {
        let levels = Set<Level>([Level(id: nil), Level(id: nil)])
        let levelList = LevelListViewModel(levels: levels)

        XCTAssertEqual(levelList.levelArray,
                       Array(levels).sorted(by: { $0.updatedAt.compare($1.updatedAt) == .orderedDescending }),
                       "Level list with filled level set should return filled level array.")
    }

    func testAddLevel_emptyLevelSet() {
        let level = Level(id: nil)
        let levelList = LevelListViewModel()

        levelList.addLevel(level)
        XCTAssertEqual(levelList.levels, [level],
                       "Level list with empty level set should have filled level set.")
    }

    func testAddLevel_filledLevelSetAndAddingNonExistingLevel() {
        let level = Level(id: nil)
        var levels = Set<Level>([Level(id: nil), Level(id: nil)])
        let levelList = LevelListViewModel(levels: levels)

        levelList.addLevel(level)
        levels.insert(level)
        XCTAssertEqual(levelList.levels, levels,
                       "Level list with filled level set should have different filled level set.")
    }

    func testAddLevel_filledLevelSetAndAddingExistingLevel() {
        let level = Level(id: nil)
        let levels = Set<Level>([level, Level(id: nil)])
        let levelList = LevelListViewModel(levels: levels)

        levelList.addLevel(level)
        XCTAssertEqual(levelList.levels, levels,
                       "Level list with filled level set should have same filled level set.")
    }

    func testDeleteLevel_emptyLevelSet() {
        let level = Level(id: nil)
        let levelList = LevelListViewModel()

        levelList.deleteLevel(level)
        XCTAssertEqual(levelList.levels, [],
                       "Level list with empty level set should have empty level set.")
    }

    func testDeleteLevel_filledLevelSetAndDeletingNonExistingLevel() {
        let level = Level(id: nil)
        let levels = Set<Level>([Level(id: nil), Level(id: nil)])
        let levelList = LevelListViewModel(levels: levels)

        levelList.deleteLevel(level)
        XCTAssertEqual(levelList.levels, levels,
                       "Level list with filled level set should have same filled level set.")
    }

    func testDeleteLevel_filledLevelSetAndDeletingExistingLevel() {
        let level = Level(id: nil)
        var levels = Set<Level>([level, Level(id: nil)])
        let levelList = LevelListViewModel(levels: levels)

        levelList.deleteLevel(level)
        levels.remove(level)
        XCTAssertEqual(levelList.levels, levels,
                       "Level list with filled level set should have different filled level set.")
    }

    func testLoadLevels_emptyLevelSetAndLoadingEmptyLevelSet() {
        let levels = Set<Level>()
        let levelList = LevelListViewModel()

        levelList.loadLevels(levels)
        XCTAssertEqual(levelList.levels, levels,
                       "Level list with empty level set should have empty level set.")
    }

    func testLoadLevels_emptyLevelSetAndLoadingFilledLevelSet() {
        let levels = Set<Level>([Level(id: nil), Level(id: nil)])
        let levelList = LevelListViewModel()

        let exp = expectation(description: "Loading levels")
        levelList.loadLevels(levels)
        DispatchQueue.main.async {
            XCTAssertEqual(levelList.levels, levels,
                           "Level list with empty level set should have filled level set.")
            exp.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)
    }

    func testLoadLevels_filledLevelSetAndLoadingEmptyLevelSet() {
        let levels = Set<Level>()
        let levelList = LevelListViewModel(levels: [Level(id: nil), Level(id: nil)])

        let exp = expectation(description: "Loading levels")
        levelList.loadLevels(levels)
        DispatchQueue.main.async {
            XCTAssertEqual(levelList.levels, levels,
                           "Level list with empty level set should have empty level set.")
            exp.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)
    }

    func testLoadLevels_filledLevelSetAndLoadingFilledLevelSet() {
        let levels = Set<Level>([Level(id: nil), Level(id: nil)])
        let levelList = LevelListViewModel(levels: [Level(id: nil), Level(id: nil)])

        let exp = expectation(description: "Loading levels")
        levelList.loadLevels(levels)
        DispatchQueue.main.async {
            XCTAssertEqual(levelList.levels, levels,
                           "Level list with empty level set should have filled level set.")
            exp.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)
    }

}
