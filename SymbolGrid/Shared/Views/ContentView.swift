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
    @State private var showingFavorites = false
    @State private var searchText = ""
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
#endif
        } else {
            ZStack {
                SymbolView(
                    fontSize: $fontSize,
                    selectedWeight: $selectedWeight,
                    selectedSample: $selectedSample,
                    showingSymbolMenu: $showingSymbolMenu,
                    showingSearch: $showingSearch,
                    showingFavorites: $showingFavorites,
                    searchText: $searchText,
                    searchResults: searchResults,
                    favoriteSuggestions: favoriteSuggestions
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

    var searchResults: [String] {
        return filterResults(sys.symbols)
    }

    var favoriteSuggestions: [String] {
        return filterResults(favorites.map { $0.glyph })
    }

    func filterResults(_ list: [String]) -> [String] {
        return list.filter { key in
            return applyFilters(to: key) && containsSearchText(key)
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
