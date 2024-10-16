//
//  ContentView.swift
//  SymbolView
//
//  Created by Dalton Alexandre on 5/24/24.
//

import SwiftUI
import Design
import SFSymbolKit
import UniformTypeIdentifiers
import CoreSpotlight
import SwiftData

struct ContentView: View {
    @State private var sys = Localizations()
    @Query var favorites: [Favorite]
    @State private var fontSize = 50.0
    @State private var selectedWeight: Weight = .regular
    @State private var selectedMode: SymbolRenderingModes = .monochrome
    @State private var showingSymbolMenu = false
    @State private var showingSearch = false
    @State private var showingDetail = false
    @State private var showingFavorites = false
    @State private var searchText = ""
    @State private var searchScope: SearchScope = .all
    @State private var searchTokens: [SearchToken] = []
    @State private var isAnimating = true

    let symbols: [Symbol]

    var body: some View {
        @State var hasFavorites = !favorites.isEmpty
        let icons: [Symbol] = Array(searchResults)
        let firstSymbols = Array(icons.prefix(200))

        if isAnimating {
            SplashView(
                fontSize: $fontSize,
                selectedWeight: $selectedWeight,
                isAnimating: $isAnimating,
                firstSymbols: firstSymbols
            )
#if os(macOS)
            .task {
                handleSearch()
            }
#endif
        } else {
            ZStack {
                SymbolView(
                    icons: icons,
                    fontSize: $fontSize,
                    selectedWeight: $selectedWeight,
                    selectedMode: $selectedMode,
                    showingSymbolMenu: $showingSymbolMenu,
                    showingDetail: $showingDetail,
                    showingFavorites: $showingFavorites,
                    showingSearch: $showingSearch,
                    searchText: $searchText,
                    searchScope: $searchScope,
                    searchTokens: $searchTokens,
                    handleSearch: handleSearch
                )
#if os(iOS)
                if showingSymbolMenu {
                    SymbolMenu(
                        fontSize: $fontSize,
                        selectedWeight: $selectedWeight,
                        selectedMode: $selectedMode,
                        showingSymbolMenu: $showingSymbolMenu,
                        showingSearch: $showingSearch,
                        showingFavorites: $showingFavorites
                    )
                    .padding(.top)
                }
#endif
            }
            .edgesIgnoringSafeArea(.all)
        }
    }

    @State private var filteredSymbols: [Symbol] = []

    var searchResults: [Symbol] {
        do {
            return try filterResults(symbols, tokens: searchTokens)
        } catch {
            return []
        }
    }

    func filterResults(_ list: [Symbol], tokens: [SearchToken]) throws -> [Symbol] {
        return list.filter { symbol in
            let matchesScope = (
                searchScope != .favorites || favorites.isEmpty || favorites.contains { $0.glyph == symbol.name
                })
            let matchesTokens = tokens.allSatisfy { token in
                symbol.name.lowercased().contains(token.text.lowercased())
            }
            return matchesScope &&
            matchesTokens &&
            applyFilters(to: symbol.name) &&
            containsSearchText(symbol.name)
        }
    }

    public func handleSearch() {
        // Split searchText into tokens
        let newKeywords = searchText.split(separator: " ").map { String($0).lowercased() }
        let newTokens = newKeywords.map { SearchToken(text: $0) }

        // Append new tokens to existing searchTokens
        searchTokens.append(contentsOf: newTokens)

        // Clear the current search text
        searchText = ""

        // Filter search results based on tokens
        filteredSymbols = symbols.filter { symbol in
            searchTokens.allSatisfy { token in
                symbol.name.lowercased().contains(token.text)
            }
        }
    }

    func containsSearchText(_ key: String) -> Bool {
        return searchText.isEmpty || key.contains(searchText.lowercased())
    }

    func applyFilters(to key: String) -> Bool {
        let suffixSettings: [String: Bool] = [
            ".ar": sys.arabicSetting,
            ".bn": sys.bengaliSetting,
            ".my": sys.burmeseSetting,
            ".zh": sys.chineseSetting,
            ".gu": sys.gujaratiSetting,
            ".he": sys.hebrewSetting,
            ".hi": sys.hindiSetting,
            ".ja": sys.japaneseSetting,
            ".kn": sys.kannadaSetting,
            ".km": sys.khmerSetting,
            ".ko": sys.koreanSetting,
            ".el": sys.latinSetting,
            ".ml": sys.malayalamSetting,
            ".mni": sys.manipuriSetting,
            ".mr": sys.marathiSetting,
            ".or": sys.oriyaSetting,
            ".ru": sys.russianSetting,
            ".sat": sys.santaliSetting,
            ".si": sys.sinhalaSetting,
            ".ta": sys.tamilSetting,
            ".te": sys.teluguSetting,
            ".th": sys.thaiSetting,
            ".pa": sys.punjabiSetting
        ]

        for (suffix, setting) in suffixSettings {
            if !setting && key.hasSuffix(suffix) {
                return false
            }
        }
        return true
    }
}

#Preview {
    ContentView(symbols: [])
}
