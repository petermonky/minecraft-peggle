//
//  LevelDesignerViewModelTests.swift
//  PeggleTests
//
//  Created by Peter Jung on 2023/01/28.
//

import XCTest
@testable import Peggle

final class LevelDesignerViewModelTests: XCTestCase {

    func testConstruct() {
        let levelDesignerViewModel = LevelDesignerViewModel()

        XCTAssertTrue(levelDesignerViewModel.paletteViewModel.mode == .bluePeg
                      && levelDesignerViewModel.paletteViewModel.pegFactory is BluePegFactory,
                      "Level designer view model should be initialised with default palette view model.")
        XCTAssertTrue(levelDesignerViewModel.boardViewModel.pegViewModels.isEmpty
                      && levelDesignerViewModel.boardViewModel.initialBoardSize == nil
                      && levelDesignerViewModel.boardViewModel.currentBoardSize == nil,
                       "Level designer view model should be initialised with default board view model.")
        XCTAssertEqual(levelDesignerViewModel.actionViewModel.title, "",
                       "Level designer view model should be initialised with default action view model.")
        XCTAssertEqual(levelDesignerViewModel.levelListViewModel.levels, [],
                       "Level designer view model should be initialised with default level list view model.")
    }

}
