//
//  PaletteButtonViewModelTests.swift
//  PeggleTests
//
//  Created by Peter Jung on 2023/01/28.
//

import XCTest
@testable import Peggle

final class PaletteButtonViewModelTests: XCTestCase {

    func testConstruct_emptyParameters() {
        let paletteButtonViewModel = PaletteButtonViewModel()

        XCTAssertEqual(paletteButtonViewModel.paletteButton.type, .bluePeg,
                       "Palette button view model should be initialised with blue peg button.")
    }

    func testConstruct_filledParameters() {
        let paletteButtonViewModel = PaletteButtonViewModel(paletteButton: OrangePegPaletteButton())

        XCTAssertEqual(paletteButtonViewModel.paletteButton.type, .orangePeg,
                       "Palette button view model should be initialised with orange peg button.")
    }

}
