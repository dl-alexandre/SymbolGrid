//
//  XCSymbolTest.swift
//  SymbolGridTests
//
//  Created by Dalton Alexandre on 11/3/24.
//

import XCTest
import SFSymbolKit
@testable import SymbolGrid
import SwiftUI

final class SymbolGridXCTest: XCTestCase {

    let symbols = Array(convertSymbols(categorization: Categorizer(), symbolization: Symbolizer()))

    func testInitialization() throws {
        // Initialize ContentView
        let symbols = [Symbol(name: "Example1"), Symbol(name: "Example2")]
        let contentView = ContentView(symbols: symbols)

        // Access properties
        let sys = contentView.sys
        XCTAssertNotNil(sys, "sys should be initialized")

        let favorites = contentView.favorites
        XCTAssertEqual(favorites.count, 0, "favorites should be initialized as an empty array")

        let fontSize = contentView.fontSize
        XCTAssertEqual(fontSize, 50.0, "The fontSize should be initialized to 50.0")

        let selectedWeight = contentView.selectedWeight
        XCTAssertEqual(selectedWeight, .regular, "The selectedWeight should be initialized to .regular")

        let selectedMode = contentView.selectedMode
        XCTAssertEqual(selectedMode, .monochrome, "The selectedMode should be initialized to .monochrome")

        let showingSymbolMenu = contentView.showingSymbolMenu
        XCTAssertFalse(showingSymbolMenu, "The showingSymbolMenu should be initialized to false")

        let showingSearch = contentView.showingSearch
        XCTAssertFalse(showingSearch, "The showingSearch should be initialized to false")

        let showingDetail = contentView.showingDetail
        XCTAssertFalse(showingDetail, "The showingDetail should be initialized to false")

        let showingFavorites = contentView.showingFavorites
        XCTAssertFalse(showingFavorites, "The showingFavorites should be initialized to false")

        let searchText = contentView.searchText
        XCTAssertEqual(searchText, "", "The searchText should be initialized to an empty string")

        let searchScope = contentView.searchScope
        XCTAssertEqual(searchScope, .all, "The searchScope should be initialized to .all")

        let searchTokens = contentView.searchTokens
        XCTAssertEqual(searchTokens, [], "The searchTokens should be initialized to an empty array")

        let isAnimating = contentView.isAnimating
        XCTAssertTrue(isAnimating, "The isAnimating should be initialized to true")

        let hasFavorites = contentView.hasFavorites
        XCTAssertFalse(hasFavorites, "The hasFavorites should be initialized to true")

        let icons = contentView.icons
        XCTAssertEqual(icons, symbols, "The icons should be initialized as example Symbols")

        let firstSymbols = contentView.firstSymbols
        XCTAssertEqual(firstSymbols, symbols, "The firstSymbols should be initialized as example Symbols")

        let filteredSymbols = contentView.filteredSymbols
        XCTAssertEqual(filteredSymbols, [], "The filteredSymbols should be initialized to an empty array")
    }
}
