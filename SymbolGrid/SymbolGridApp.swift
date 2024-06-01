//
//  SymbolViewApp.swift
//  SymbolView
//
//  Created by Dalton Alexandre on 5/24/24.
//

import SwiftUI
import SFSymbolKit

@main
struct SymbolGridApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
#if os(macOS)
        .windowStyle(HiddenTitleBarWindowStyle())
#endif
#if os(macOS)
        Settings {
            SettingsView()
        }
        .commands {
            SymbolCommands()
        }
#endif
    }
}

struct ContentView: View {
    @StateObject private var tabModel: TabModel = .init()
    #if os(macOS)
    @Environment(\.controlActiveState) private var state
    #endif
    var body: some View {
            TabView(selection: $tabModel.activeTab) {
                HomeView(symbols: system.symbols)
                    .transition(.move(edge: .bottom))
//                    .toolbar(.hidden)
#if os(iOS)
                    .tag(0)
#elseif os(macOS)
                    .tag(Tab.home).tabItem {
                        Text("Symbols")
                    }
                
                    .background(HideTabBar())
#endif
                FavoritesView(renderMode: $selectedSample, fontWeight: $selectedWeight)
#if os(iOS)
                    .tag(1)
#elseif os(macOS)
                    .tag(Tab.favorites).tabItem {
                        Text("Favorites")
                    }
#endif
                
            }
        #if os(macOS)
            .background {
                GeometryReader {
                    let rect = $0.frame(in: .global)
                    
                    Color.clear
                        .onChange(of: rect) { oldValue, newValue in
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
    }
    @AppStorage("tab") var selectedTab = 0
    @State private var selectedSample = RenderModes.monochrome
    @State private var selectedWeight = FontWeights.medium
    @State private var isActive: Bool = true
    @State private var system = System()
}

