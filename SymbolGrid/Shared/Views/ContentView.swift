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

struct ContentView: View {
    @State private var fontSize = 50.0
    @State private var selectedWeight: Weight = .regular
    @State private var selectedSample: SymbolRenderingModes = .monochrome
    @State private var showingSymbolMenu = false
    @State private var showingSearch = false
    @State private var showingFavorites = false
    @State private var isAnimating = true

    var body: some View {
        if isAnimating {
            SplashView(
                fontSize: $fontSize,
                selectedWeight: $selectedWeight,
                isAnimating: $isAnimating
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
                    showingFavorites: $showingFavorites
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
}

#Preview {
    ContentView()
}
