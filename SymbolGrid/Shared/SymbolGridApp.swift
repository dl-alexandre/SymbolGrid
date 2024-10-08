//
//  SymbolViewApp.swift
//  SymbolView
//
//  Created by Dalton Alexandre on 5/24/24.
//

import SwiftUI
import SwiftData
import SFSymbolKit

@main
struct SymbolGridApp: App {
    let symbols: [Symbol]

    init() {
        let categorizor = Categorizer()
        let symbolizer = Symbolizer()
        self.symbols = convertSymbols(categorization: categorizor, symbolization: symbolizer)
        registerDefaultsFromSettingsBundle()
        hideNavigationBar()
    }

    var body: some Scene {
        WindowGroup {
            ContentView(symbols: symbols)
                .modelContainer(sharedModelContainer)

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

    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Favorite.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {

            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
}
