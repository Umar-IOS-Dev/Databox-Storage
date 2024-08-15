//
//  CloudVaultUITests.swift
//  CloudVaultUITests
//
//  Created by Appinators Technology on 08/07/2024.
//

import XCTest

final class CloudVaultUITests: XCTestCase {

    var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    override func tearDownWithError() throws {
        app = nil
    }

    func testExample() throws {
        let settingsButton = app.buttons["Settings"]
        XCTAssertTrue(waitForElementToAppear(element: settingsButton), "Settings button should exist")
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
    
    func testSettingsNavigation() throws {
        let settingsButton = app.buttons["Settings"]
        XCTAssertTrue(waitForElementToAppear(element: settingsButton), "Settings button should exist")
        settingsButton.tap()

        let settingsTitle = app.staticTexts["Settings"]
        XCTAssertTrue(waitForElementToAppear(element: settingsTitle), "Settings title should exist")
    }

    func testManageStorageButton() throws {
        navigateToSettings()
        
        let manageStorageButton = app.buttons["Manage Storage"]
        XCTAssertTrue(waitForElementToAppear(element: manageStorageButton), "Manage Storage button should exist")
        manageStorageButton.tap()

        // Verify the result of tapping the Manage Storage button
    }
    
    func testPrivacyPolicyButton() throws {
        navigateToSettings()
        
        let privacyPolicyButton = app.buttons["Privacy Policy"]
        XCTAssertTrue(waitForElementToAppear(element: privacyPolicyButton), "Privacy Policy button should exist")
        privacyPolicyButton.tap()

        // Verify the result of tapping the Privacy Policy button
    }
    
    func testTermsAndConditionsButton() throws {
        navigateToSettings()
        
        let termsAndConditionsButton = app.buttons["Terms And Conditions"]
        XCTAssertTrue(waitForElementToAppear(element: termsAndConditionsButton), "Terms And Conditions button should exist")
        termsAndConditionsButton.tap()

        // Verify the result of tapping the Terms And Conditions button
    }

    private func navigateToSettings() {
        let settingsButton = app.buttons["Settings"]
        XCTAssertTrue(waitForElementToAppear(element: settingsButton), "Settings button should exist")
        settingsButton.tap()
    }
    
    private func waitForElementToAppear(element: XCUIElement, timeout: TimeInterval = 10) -> Bool {
        let existsPredicate = NSPredicate(format: "exists == true")
        let expectation = XCTNSPredicateExpectation(predicate: existsPredicate, object: element)
        let result = XCTWaiter().wait(for: [expectation], timeout: timeout)
        return result == .completed
    }
}



