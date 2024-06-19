//
//  ContentView.swift
//  SymbolGrid
//
//  Created by Dalton Alexandre on 6/2/24.
//

import SwiftUI
import SFSymbolKit

struct ContentView: View {
    var body: some View {
        ZStack {
            TabView(selection: $tabModel.activeTab) {
                if isAnimating {
                    SplashView(symbols: system.symbols, fontWeight: $selectedWeight, isAnimating: $isAnimating)
                        .tag(Tab.home)
#if os(macOS)
                        .background(HideTabBar())
#endif
                } else {
                    HomeView(symbols: system.symbols).environmentObject(tabModel)
                        .transition(.blurReplace)
                        .tag(Tab.home)
#if os(macOS)
                        .background(HideTabBar())
#endif
                }
                FavoritesView(renderMode: $selectedSample, fontWeight: $selectedWeight)
                    .environmentObject(tabModel)
                    .tag(Tab.favorites)
            }
            .edgesIgnoringSafeArea(.all)
#if os(macOS)
            .background {
                GeometryReader {
                    let rect = $0.frame(in: .global)
                    
                    Color.clear
                        .onChange(of: rect) { _, _ in
                            tabModel.updateTabPosition()
                        }
                }
            }
            .onChange(of: state) { oldValue, newValue in
                if newValue == .key {
                    tabModel.addTabBar()
                }
            }
#endif
#if os(iOS)
            .tabViewStyle(.page(indexDisplayMode: .never))
#else
            .tabViewStyle(DefaultTabViewStyle())
#endif
            if showingSearch {
                searchBar(text: $searchText, focus: $searchField, showingSearch: $showingSearch)
#if os(iOS)
                    .keyboardAdaptive()
                    .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)) { _ in
                        searchField = nil
                        showingSearch = false
                    }
                    .onTapGesture(count: 3) {
                        searchText = ""
                    }
#endif
            }
        }
    }
    @EnvironmentObject private var tabModel: TabModel
#if os(macOS)
    @Environment(\.controlActiveState) private var state
#endif
    @State private var isAnimating = true
    @State private var selectedSample = RenderModes.monochrome
    @State private var selectedWeight = FontWeights.medium
    @State private var isActive: Bool = true
    @State private var system = System()
    
    @AppStorage("showingSearch") var showingSearch = false
    @AppStorage("searchText") var searchText = ""
    @FocusState private var searchField: Field?
}

#Preview {
    @Previewable var tabModel = TabModel()
    ContentView().environmentObject(tabModel)
}
