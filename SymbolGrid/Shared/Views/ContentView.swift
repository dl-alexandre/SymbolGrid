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
    @Environment(\.modelContext) var moc
    @State private var sys = System()
    @Query var favorites: [Favorite]
    @State private var fontSize = 50.0
    @State private var selectedWeight: Weight = .regular
    @State private var selectedSample: SymbolRenderingModes = .monochrome
    @State private var showingSymbolMenu = false
    @State private var showingSearch = false
    @State private var showingDetail = false
    @State private var showingFavorites = false
    @State private var searchText = ""
    @State private var searchScope: SymbolCategory = .all
    @State private var searchTokens: [SearchToken] = []
    @State private var isAnimating = true


    var body: some View {
        if isAnimating {
            SplashView(
                fontSize: $fontSize,
                selectedWeight: $selectedWeight,
                isAnimating: $isAnimating,
                searchResults: searchResults
            )
#if os(macOS)
            .background(HideTabBar())

            .task {
                handleSearch()
            }
#endif
        } else {
            ZStack {
                SymbolView(
                    fontSize: $fontSize,
                    selectedWeight: $selectedWeight,
                    selectedSample: $selectedSample,
                    showingSymbolMenu: $showingSymbolMenu,
                    showingDetail: $showingDetail,
                    showingSearch: $showingSearch,
                    showingFavorites: $showingFavorites,
                    searchText: $searchText,
                    searchScope: $searchScope,
                    searchTokens: $searchTokens,
                    searchResults: searchResults,
                    favoriteSuggestions: favoriteSuggestions,
                    handleSearch: handleSearch
                )
#if os(iOS)
                if showingSymbolMenu {
                    SymbolMenu(
                        fontSize: $fontSize,
                        selectedWeight: $selectedWeight,
                        selectedSample: $selectedSample,
                        showingSymbolMenu: $showingSymbolMenu,
                        showingSearch: $showingSearch,
                        showingFavorites: $showingFavorites
                    )
                    .padding(.top)
                }
#endif
            }
            .edgesIgnoringSafeArea(.all)
#if os(macOS)
            .background(HideTabBar())
#endif
        }
    }

    @State private var filteredSymbols: [Symbol] = []
    @State private var filteredFavoriteSuggestions: [Symbol] = []

    var searchResults: [Symbol] {
        return filterResults(sys.symbols)
    }

    var favoriteSuggestions: [Symbol] {
        return filterResults(filteredFavoriteSuggestions)
    }

    func filterResults(_ list: [Symbol]) -> [Symbol] {
        return list.filter { key in
            let matchesScope: Bool
            switch searchScope {
            case .multicolor:
                matchesScope = key.categories.contains(.multicolor)
            case .variablecolor:
                matchesScope = key.categories.contains(.variablecolor)
            default:
                matchesScope = true
            }
            return matchesScope && applyFilters(to: key.name) && containsSearchText(key.name)
        }
    }

    public func handleSearch() {
        // Split searchText into tokens
        let keywords = searchText.split(separator: " ").map { String($0) }
        searchTokens = keywords.map { SearchToken(text: $0) }

        // Clear the current search text
        searchText = ""

        // Filter search results based on tokens
        filteredSymbols = sys.symbols
        for token in searchTokens {
            filteredSymbols = filteredSymbols.filter { symbol in
                containsSearchText(token.text)
            }
        }

        // Filter favorite suggestions based on tokens
        let favoriteSymbols = favorites.map { favorite in
            Symbol(name: favorite.glyph, categories: [])
        }
        
        filteredFavoriteSuggestions = filteredSymbols
        for token in searchTokens {
            filteredFavoriteSuggestions = filteredFavoriteSuggestions.filter { symbol in
                containsSearchText(token.text)
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
    ContentView()
}
