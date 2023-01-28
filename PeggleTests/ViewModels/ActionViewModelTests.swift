//
//  ActionViewModelTests.swift
//  PeggleTests
//
//  Created by Peter Jung on 2023/01/27.
//

import XCTest
@testable import Peggle

final class ActionViewModelTests: XCTestCase {

    func testConstruct_emptyParameters() {
        let actionViewModel = ActionViewModel()

        XCTAssertEqual(actionViewModel.title, "", "Action view model should be initialised with empty title")
    }

    func testConstruct_filledParameters() {
        let title = "Monkey actionViewModel 🐵"
        let actionViewModel = ActionViewModel(title: title)

        XCTAssertEqual(actionViewModel.title, title, "Action view model should be initialised with filled title")
    }

    func testIsValidForm_emptyForm_isInvalid() {
        let actionViewModel = ActionViewModel()

        XCTAssertFalse(actionViewModel.isValidForm, "Action view model with empty form should have invalid form.")
    }

    func testIsValidForm_nonEmptyForm_isInvalid() {
        let title = "Monkey actionViewModel 🐵"
        let actionViewModel = ActionViewModel(title: title)

        XCTAssertTrue(actionViewModel.isValidForm, "Action view model with non-empty form should have valid form.")
    }

    func testLoadTitle_emptyString() {
        let title = "Monkey actionViewModel 🐵"
        let actionViewModel = ActionViewModel(title: title)

        let newTitle = ""
        actionViewModel.loadTitle(newTitle)
        XCTAssertEqual(actionViewModel.title, newTitle, "Action view model title should be updated to empty string.")
    }

    func testLoadTitle_nonEmptyString() {
        let title = "Monkey actionViewModel 🐵"
        let actionViewModel = ActionViewModel(title: title)

        let newTitle = "Cat actionViewModel 🐱"
        actionViewModel.loadTitle(newTitle)
        XCTAssertEqual(actionViewModel.title, newTitle, "Action view model title should be updated to new string.")
    }

    func testResetTitle_emptyString() {
        let title = ""
        let actionViewModel = ActionViewModel(title: title)

        actionViewModel.resetTitle()
        XCTAssertEqual(actionViewModel.title, "", "Action view model title should be reset to empty string.")
    }

    func testResetTitle_nonEmptyString() {
        let title = "Monkey actionViewModel 🐵"
        let actionViewModel = ActionViewModel(title: title)

        actionViewModel.resetTitle()
        XCTAssertEqual(actionViewModel.title, "", "Action view model title should be reset to empty string.")
    }

}
