//
//  SymbolGridUITests.swift
//  SymbolGridUITests
//
//  Created by Dalton Alexandre on 5/31/24.
//

import XCTest

final class SymbolGridUITests: XCTestCase {
    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called post invocation of each test method in the class.
    }

    private func launchApp() -> XCUIApplication {
        let app = XCUIApplication()
        app.launch()
        return app
    }

    private func tapIcons(_ app: XCUIApplication, indices: [Int]) {
        let elementsQuery = app.scrollViews.otherElements
        for index in indices {
            elementsQuery.buttons["iconButton-\(index)"].tap()
        }
    }

    private func refresh(_ app: XCUIApplication, element: XCUIElement) {
        let startCoordinate = element.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.5))
        let endCoordinate = startCoordinate.withOffset(CGVector(dx: 0, dy: 600))
        startCoordinate.press(forDuration: 0.1, thenDragTo: endCoordinate)
    }

    func testTapFiveSymbols() throws {
        let app = launchApp()
        tapIcons(app, indices: [0, 1, 2, 3, 4])
    }

    func testAddRemoveFavorite() throws {
        let app = launchApp()
        tapIcons(app, indices: [5])
        app.buttons["favorite"].tap()
        app.buttons["showFavorites"].tap()
        app.collectionViews.staticTexts["favoriteRow-0"].swipeRight()
        app.collectionViews.buttons["removeFavorite-0"].tap()
    }

    func testSymbolRenderingPicker() throws {
        let app = launchApp()
        sleep(5)
        let elementsQuery = app.scrollViews.otherElements
        refresh(app, element: elementsQuery.buttons["iconButton-0"])
        app.pickerWheels["Underline, Monochrome"].swipeUp()
        app.pickerWheels["Underline, Palette"].swipeDown()
    }

    func testFontWeightPicker() throws {
        let app = launchApp()
        sleep(5)
        let elementsQuery = app.scrollViews.otherElements
        refresh(app, element: elementsQuery.buttons["iconButton-0"])
        app.pickerWheels["Regular"].swipeUp()
        app.pickerWheels["UltraLight"].swipeDown()
    }
}

