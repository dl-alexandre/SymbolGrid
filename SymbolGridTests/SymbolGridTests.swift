//
//  SymbolGridTests.swift
//  SymbolGridTests
//
//  Created by Dalton Alexandre on 5/31/24.
//

import XCTest
@testable import SymbolGrid

final class SymbolGridTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

    func testAllFonts() {
        let size: CGFloat = 12
        postScriptNames.forEach { fontName in
            // Convert SwiftUI Font to CTFont to test its existence
            let ctFont = CTFontCreateWithName(fontName as CFString, size, nil)
            XCTAssertNotNil(ctFont, "Custom font \(fontName) should be loaded.")
        }
    }
}
