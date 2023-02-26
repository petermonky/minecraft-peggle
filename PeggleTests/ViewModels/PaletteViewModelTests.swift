//
//  PaletteViewModelTests.swift
//  PeggleTests
//
//  Created by Peter Jung on 2023/01/28.
//

import XCTest
@testable import Peggle

final class PaletteViewModelTests: XCTestCase {

    func testConstruct() {
        let paletteViewModel = PaletteViewModel()

        XCTAssertEqual(paletteViewModel.mode, .bluePeg,
                       "Palette view model should be initialised with blue peg palette button.")
        XCTAssertTrue(paletteViewModel.pegFactory is BluePegFactory,
                      "Palette view model should be initialised with blue peg factory.")
    }

    func testPegButtonViewModels() {
        let paletteViewModel = PaletteViewModel()

        XCTAssertTrue(paletteViewModel.pegButtonViewModels[0].paletteButton is BluePegPaletteButton,
                      "Palette view model should show blue peg palette button first.")
        XCTAssertTrue(paletteViewModel.pegButtonViewModels[1].paletteButton is RedPegPaletteButton,
                      "Palette view model should show orange peg palette button second.")
    }

    func testDeleteButtonViewModel() {
        let paletteViewModel = PaletteViewModel()

        XCTAssertTrue(paletteViewModel.deleteButtonViewModel.paletteButton is DeletePegPaletteButton,
                      "Palette view model should show delete peg palette button last.")
    }

    func testOnPegButtonSelect() {
        let paletteViewModel = PaletteViewModel()

        paletteViewModel.onPegButtonSelect(pegButton: RedPegPaletteButton())
        XCTAssertEqual(paletteViewModel.mode, .orangePeg,
                       "Palette view model should adopt orange peg palette button.")
        XCTAssertTrue(paletteViewModel.pegFactory is RedPegFactory,
                      "Palette view model should adopt orange peg factory.")
    }

    func testOnDeleteButtonSelect() {
        let paletteViewModel = PaletteViewModel()

        paletteViewModel.onDeleteButtonSelect()
        XCTAssertEqual(paletteViewModel.mode, .delete,
                       "Palette view model should adopt delete peg palette button.")
        XCTAssertNil(paletteViewModel.pegFactory,
                     "Palette view model should remove peg factory.")
    }

}
