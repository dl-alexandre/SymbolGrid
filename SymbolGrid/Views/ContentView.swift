//
//  ContentView.swift
//  SymbolGrid
//
//  Created by Dalton Alexandre on 6/2/24.
//

import SwiftUI
import SFSymbolKit

struct ContentView: View {
    @EnvironmentObject private var tabModel: TabModel
#if os(macOS)
    @Environment(\.controlActiveState) private var state
#endif
    var body: some View {
        TabView(selection: $tabModel.activeTab) {
            HomeView(symbols: system.symbols).environmentObject(tabModel)
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
            FavoritesView(renderMode: $selectedSample, fontWeight: $selectedWeight).environmentObject(tabModel)
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
    }
    //    @AppStorage("tab") var selectedTab = 0
    @State private var selectedSample = RenderModes.monochrome
    @State private var selectedWeight = FontWeights.medium
    @State private var isActive: Bool = true
    @State private var system = System()
}



#Preview {
    ContentView()
}
