//
//  BoardViewModelTests.swift
//  PeggleTests
//
//  Created by Peter Jung on 2023/01/28.
//

import XCTest
@testable import Peggle

final class BoardViewModelTests: XCTestCase {

    func testConstruct_emptyParameters() {
        let boardViewModel = BoardViewModel()

        XCTAssertEqual(boardViewModel.pegViewModels, [],
                       "Board view model should be initialised with empty set of peg view models.")
        XCTAssertEqual(boardViewModel.initialBoardSize, CGSize.zero,
                       "Board view model should be initialised with initial board size of CGSize.zero.")
        XCTAssertEqual(boardViewModel.currentBoardSize, CGSize.zero,
                       "Board view model should be initialised with current board size of CGSize.zero.")
    }

    func testConstruct_filledParameters() {
        let pegViewModels = Set([PegViewModel(), PegViewModel()])
        let boardViewModel = BoardViewModel(pegViewModels: pegViewModels)

        XCTAssertEqual(boardViewModel.pegViewModels, pegViewModels,
                       "Board view model should be initialised with filled set of peg view models.")
        XCTAssertEqual(boardViewModel.initialBoardSize, CGSize.zero,
                       "Board view model should be initialised with initial board size of CGSize.zero.")
        XCTAssertEqual(boardViewModel.currentBoardSize, CGSize.zero,
                       "Board view model should be initialised with current board size of CGSize.zero.")
    }

    func testPegArray_emptyPegViewModels() {
        let boardViewModel = BoardViewModel()

        XCTAssertEqual(boardViewModel.levelObjectsArray, [], "Board view model should have empty peg array.")
    }

    func testPegArray_nonEmptyPegViewModels() {
        let pegViewModels = Set([PegViewModel(), PegViewModel()])
        let boardViewModel = BoardViewModel(pegViewModels: pegViewModels)

        XCTAssertEqual(Set(boardViewModel.levelObjectsArray), Set( Array(pegViewModels).map { $0.peg }),
                       "Board view model should have non-empty peg array.")
    }

    func testSizeScale_nilBoardSize() {
        let boardViewModel = BoardViewModel()

        XCTAssertEqual(boardViewModel.sizeScale, 1,
                       "Board view model should have size scale of 1.")
    }

    func testSizeScale_nonNilBoardSize() {
        let boardViewModel = BoardViewModel()

        boardViewModel.initialBoardSize = CGSize(width: 100, height: 100)
        boardViewModel.currentBoardSize = CGSize(width: 200, height: 200)
        XCTAssertEqual(boardViewModel.sizeScale, 2,
                       "Board view model should have size scale of 2.")
    }

    func testInitialiseBoardSize() {
        let boardViewModel = BoardViewModel()

        boardViewModel.initialiseBoardSize(boardSize: CGSize(width: 100, height: 100))
        XCTAssertEqual(boardViewModel.initialBoardSize, CGSize(width: 100, height: 100),
                       "Board view model should have initial board size of (100, 100).")
        XCTAssertEqual(boardViewModel.currentBoardSize, CGSize(width: 100, height: 100),
                       "Board view model should have current board size of (100, 100).")
    }

    func testUpdateBoardSize() {
        let boardViewModel = BoardViewModel()

        boardViewModel.initialiseBoardSize(boardSize: CGSize.zero)
        boardViewModel.updateBoardSize(boardSize: CGSize(width: 100, height: 100))
        XCTAssertEqual(boardViewModel.initialBoardSize, CGSize.zero,
                       "Board view model should have initial board size of CGSize.zero.")
        XCTAssertEqual(boardViewModel.currentBoardSize, CGSize(width: 100, height: 100),
                       "Board view model should have current board size of (100, 100).")
    }

    func testLoadPegs_emptyPegViewModels() {
        let boardViewModel = BoardViewModel()

        boardViewModel.loadLevelObjects([])
        XCTAssertEqual(boardViewModel.pegViewModels, [],
                       "Board view model should have empty set of peg view models after load.")
    }

    func testLoadPegs_nonEmptyPegViewModels() {
        let pegViewModels = [PegViewModel(), PegViewModel()]
        let boardViewModel = BoardViewModel()

        boardViewModel.loadLevelObjects(pegViewModels)
        XCTAssertEqual(boardViewModel.pegViewModels, Set(pegViewModels),
                       "Board view model should have non-empty set of peg view models after load.")
    }

    func testAddPeg_emptyPegViewModelsWithoutOverflow() {
        let pegViewModel = PegViewModel(peg: BluePeg(position: CGPoint(x: 50, y: 50)))
        let boardViewModel = BoardViewModel()

        boardViewModel.initialiseBoardSize(boardSize: CGSize(width: 200, height: 200))
        XCTAssertTrue(boardViewModel.addLevelObject(pegViewModel),
                      "Adding new peg view model to board view model should be successful.")
        XCTAssertEqual(boardViewModel.pegViewModels, [pegViewModel],
                       "Board view model should have non-empty set of peg view models after adding peg view model.")
    }

    func testAddPeg_emptyPegViewModelsWithOverflow() {
        let pegViewModel = PegViewModel()
        let boardViewModel = BoardViewModel()

        boardViewModel.initialiseBoardSize(boardSize: CGSize(width: 200, height: 200))
        XCTAssertFalse(boardViewModel.addLevelObject(pegViewModel),
                       "Adding new peg view model to board view model should not be successful.")
        XCTAssertEqual(boardViewModel.pegViewModels, [],
                       "Board view model should have empty set of peg view models after adding peg view model.")
    }

    func testAdd_nonEmptyPegViewModelsWithoutOverlapAndWithoutOverflow() {
        let pegViewModel = PegViewModel(peg: BluePeg(position: CGPoint(x: 50, y: 50)))
        var pegViewModels = [
            PegViewModel(peg: BluePeg(position: CGPoint(x: 100, y: 100))),
            PegViewModel(peg: BluePeg(position: CGPoint(x: 150, y: 150)))
        ]
        let boardViewModel = BoardViewModel(pegViewModels: Set(pegViewModels))

        boardViewModel.initialiseBoardSize(boardSize: CGSize(width: 200, height: 200))
        pegViewModels.append(pegViewModel)
        XCTAssertTrue(boardViewModel.addPeg(pegViewModel),
                      "Adding new peg view model to board view model should be successful.")
        XCTAssertEqual(boardViewModel.pegViewModels, Set(pegViewModels),
                       "Board view model should have extended set of peg view models after adding peg view model.")
    }

    func testAdd_nonEmptyPegViewModelsWithoutOverlapAndWithOverflow() {
        let pegViewModel = PegViewModel()
        let pegViewModels = [
            PegViewModel(peg: BluePeg(position: CGPoint(x: 100, y: 100))),
            PegViewModel(peg: BluePeg(position: CGPoint(x: 150, y: 150)))
        ]
        let boardViewModel = BoardViewModel(pegViewModels: Set(pegViewModels))

        boardViewModel.initialiseBoardSize(boardSize: CGSize(width: 200, height: 200))
        XCTAssertFalse(boardViewModel.addPeg(pegViewModel),
                       "Adding new peg view model to board view model should not be successful.")
        XCTAssertEqual(boardViewModel.pegViewModels, Set(pegViewModels),
                       "Board view model should have same set of peg view models after adding peg view model.")
    }

    func testAdd_nonEmptyPegViewModelsWithOverlapAndWithoutOverflow() {
        let pegViewModel = PegViewModel(peg: BluePeg(position: CGPoint(x: 50, y: 50)))
        let pegViewModels = [
            PegViewModel(peg: BluePeg(position: CGPoint(x: 50, y: 50))),
            PegViewModel(peg: BluePeg(position: CGPoint(x: 100, y: 100))),
            PegViewModel(peg: BluePeg(position: CGPoint(x: 150, y: 150)))
        ]
        let boardViewModel = BoardViewModel(pegViewModels: Set(pegViewModels))

        boardViewModel.initialiseBoardSize(boardSize: CGSize(width: 200, height: 200))
        XCTAssertFalse(boardViewModel.addPeg(pegViewModel),
                       "Adding new peg view model to board view model should not be successful.")
        XCTAssertEqual(boardViewModel.pegViewModels, Set(pegViewModels),
                       "Board view model should have same set of peg view models after adding peg view model.")
    }

    func testAdd_nonEmptyPegViewModelsWithOverlapAndWithOverflow() {
        let pegViewModel = PegViewModel(peg: BluePeg(position: CGPoint(x: 20, y: 20)))
        let pegViewModels = [
            PegViewModel(peg: BluePeg(position: CGPoint(x: 30, y: 30))),
            PegViewModel(peg: BluePeg(position: CGPoint(x: 100, y: 100))),
            PegViewModel(peg: BluePeg(position: CGPoint(x: 150, y: 150)))
        ]
        let boardViewModel = BoardViewModel(pegViewModels: Set(pegViewModels))

        boardViewModel.initialiseBoardSize(boardSize: CGSize(width: 200, height: 200))
        XCTAssertFalse(boardViewModel.addPeg(pegViewModel),
                       "Adding new peg view model to board view model should not be successful.")
        XCTAssertEqual(boardViewModel.pegViewModels, Set(pegViewModels),
                       "Board view model should have same set of peg view models after adding peg view model.")
    }

    func testRemove_emptyPegViewModels() {
        let pegViewModel = PegViewModel()
        let boardViewModel = BoardViewModel()

        XCTAssertFalse(boardViewModel.removeLevelObject(pegViewModel),
                       "Board view model should not remove non-existing peg view model.")
        XCTAssertEqual(boardViewModel.pegViewModels, [],
                       "Board view model should have empty set of peg view models.")
    }

    func testRemove_nonEmptyPegViewModelsAndExistingPegViewModel() {
        let pegViewModel = PegViewModel()
        var pegViewModels = [PegViewModel(), pegViewModel]
        let boardViewModel = BoardViewModel(pegViewModels: Set(pegViewModels))

        pegViewModels.removeLast()
        XCTAssertTrue(boardViewModel.removePeg(pegViewModel),
                      "Board view model should remove existing peg view model.")
        XCTAssertEqual(boardViewModel.pegViewModels, Set(pegViewModels),
                       "Board view model should have peg view model removed from non-empty set of peg view models.")
    }

    func testRemove_nonEmptyPegViewModelsAndNonExistingPegViewModel() {
        let pegViewModel = PegViewModel()
        let pegViewModels = [PegViewModel(), PegViewModel()]
        let boardViewModel = BoardViewModel(pegViewModels: Set(pegViewModels))

        XCTAssertFalse(boardViewModel.removePeg(pegViewModel),
                       "Board view model should not remove non-existing peg view model.")
        XCTAssertEqual(boardViewModel.pegViewModels, Set(pegViewModels),
                       "Board view model should have same non-empty set of peg view models.")
    }

    func testTranslatePeg_existingPegViewModel() {
        let pegViewModel = PegViewModel()
        let pegViewModels = [PegViewModel(), pegViewModel]
        let boardViewModel = BoardViewModel(pegViewModels: Set(pegViewModels))

        boardViewModel.initialiseBoardSize(boardSize: CGSize(width: 200, height: 200))
        XCTAssertTrue(boardViewModel.translateLevelObject(pegViewModel, translation: CGSize(width: 100, height: 100)),
                      "Board view model should successfully translate peg.")
        XCTAssertEqual(boardViewModel.pegViewModels.count, 2,
                       "Board view model should have same number of peg view models.")
        XCTAssertFalse(boardViewModel.pegViewModels.contains(pegViewModel),
                       "Board view model should not contain original peg view model.")
    }

    func testTranslatePeg_nonExistingPegViewModel() {
        let pegViewModel = PegViewModel()
        let pegViewModels = [PegViewModel(), PegViewModel()]
        let boardViewModel = BoardViewModel(pegViewModels: Set(pegViewModels))

        boardViewModel.initialiseBoardSize(boardSize: CGSize(width: 200, height: 200))
        XCTAssertFalse(boardViewModel.translateLevelObject(pegViewModel, translation: CGSize(width: 100, height: 100)),
                       "Board view model should unsuccessfully translate peg.")
        XCTAssertEqual(boardViewModel.pegViewModels.count, 2,
                       "Board view model should have same number of peg view models.")
        XCTAssertFalse(boardViewModel.pegViewModels.contains(pegViewModel),
                       "Board view model should not contain original peg view model.")
    }

    func testResetPegs_emptyPegViewModels() {
        let boardViewModel = BoardViewModel()

        XCTAssertEqual(boardViewModel.pegViewModels, [],
                       "Board view model should initially have empty set of peg view models.")
        boardViewModel.resetLevelObjects()
        XCTAssertEqual(boardViewModel.pegViewModels, [],
                       "Board view model should ultimately have empty set of peg view models.")
    }

    func testResetPegs_nonEmptyPegViewModels() {
        let pegViewModels = [PegViewModel(), PegViewModel()]
        let boardViewModel = BoardViewModel(pegViewModels: Set(pegViewModels))

        XCTAssertEqual(boardViewModel.pegViewModels, Set(pegViewModels),
                       "Board view model should initially have non-empty set of peg view models.")
        boardViewModel.resetPegs()
        XCTAssertEqual(boardViewModel.pegViewModels, [],
                       "Board view model should ultimately have empty set of peg view models.")
    }

    func testHasOverlappingPeg_overlappingPeg() {
        let pegViewModel = PegViewModel(peg: BluePeg(position: CGPoint(x: 50, y: 50)))
        let pegViewModels = [PegViewModel(peg: BluePeg(position: CGPoint(x: 50, y: 50)))]
        let boardViewModel = BoardViewModel(pegViewModels: Set(pegViewModels))

        XCTAssertTrue(boardViewModel.hasOverlappingPeg(pegViewModel),
                      "Board view model should detect peg overlap.")
    }

    func testHasOverlappingPeg_nonOverlappingPeg() {
        let pegViewModel = PegViewModel(peg: BluePeg(position: CGPoint(x: 100, y: 100)))
        let pegViewModels = [PegViewModel(peg: BluePeg(position: CGPoint(x: 50, y: 50)))]
        let boardViewModel = BoardViewModel(pegViewModels: Set(pegViewModels))

        XCTAssertFalse(boardViewModel.hasOverlappingPeg(pegViewModel),
                       "Board view model should not detect any peg overlap.")
    }

    func testIsOverflowingPeg_overflowingPeg() {
        let pegViewModel = PegViewModel(peg: BluePeg(position: CGPoint(x: 200, y: 200)))
        let boardViewModel = BoardViewModel()

        boardViewModel.initialiseBoardSize(boardSize: CGSize(width: 100, height: 100))
        XCTAssertTrue(boardViewModel.isOverflowingPeg(pegViewModel),
                      "Board view model should detect peg overflow.")
    }

    func testIsOverflowingPeg_nonOverflowingPeg() {
        let pegViewModel = PegViewModel(peg: BluePeg(position: CGPoint(x: 50, y: 50)))
        let boardViewModel = BoardViewModel()

        boardViewModel.initialiseBoardSize(boardSize: CGSize(width: 100, height: 100))
        XCTAssertFalse(boardViewModel.isOverflowingPeg(pegViewModel),
                       "Board view model should not detect any peg overflow.")
    }

}
