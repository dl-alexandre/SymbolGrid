//
//  SymbolGridTests.swift
//  SymbolGridTests
//
//  Created by Dalton Alexandre on 5/31/24.
//

import Testing
import SFSymbolKit
@testable import SymbolGrid

@Suite("SymbolGridTests")
struct SymbolGridTests {

    func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    func tearDownWithError() throws {
        // Put teardown code here. This method is called post invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete.
        // Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.

    }

    let symbols = Array(convertSymbols(categorization: Categorizer(), symbolization: Symbolizer()))

    @Test("SymbolGrid Test")
    func testSymbolGrid() throws {
        let instance = ContentView(symbols: symbols)
        print(instance)
//        let initializedValue = instance.fontSize
        #expect(instance.icons == [], "The variable should be initialized with a double of 50.0")
//        #expect(initializedValue == 50.0, "The variable should be initialized with a double of 50.0")
    }

    @Test("Initialization Test")
    func testInitialization() throws {
        // Initialize ContentView
        let symbols = [Symbol(name: "Example1"), Symbol(name: "Example2")]
        let contentView = ContentView(symbols: symbols)

        // Access properties
        let sys = contentView.sys
        let favorites = contentView.favorites
        let fontSize = contentView.fontSize
        let selectedWeight = contentView.selectedWeight
        let selectedMode = contentView.selectedMode

        // Assert default values
        #expect(fontSize == 50.0, "The fontSize should be initialized to 50.0")
        #expect(selectedWeight == .regular, "The selectedWeight should be initialized to .regular")
        #expect(selectedMode == .monochrome, "The selectedMode should be initialized to .monochrome")

        // Check if sys is properly initialized (ensure Localizations is testable)
        #expect(sys != nil, "sys should be initialized")

        // Assert favorites (Check based on your default expected values)
        #expect(favorites.count == 0, "favorites should be initialized as an empty array")
    }
}
