//
//  SymbolViewApp.swift
//  SymbolView
//
//  Created by Dalton Alexandre on 5/24/24.
//

import SwiftUI

@main
struct SymbolGridApp: App {
    @StateObject private var tabModel: TabModel = .init()
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(tabModel)
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
