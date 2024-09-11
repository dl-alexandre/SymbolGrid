//
//  Commands.swift
//  SymbolGrid
//
//  Created by Dalton Alexandre on 5/31/24.
//

import SwiftUI
#if os(macOS)
struct SymbolCommands: Commands {
    var body: some Commands {
        SidebarCommands()
        CommandMenu("Symbols") {
            Button {
                showSearch()
            } label: {
                Label("Search", systemImage: "magnifyingglass")
            }.keyboardShortcut("s")
            Button {
                clearSearch()
            } label: {
                Label("Clear", systemImage: "delete.left")
            }.keyboardShortcut(.escape, modifiers: [])

            Button {
                fontSize = max(9, fontSize - 5)
            } label: {
                Label("Smaller", systemImage: "minus")
            }.keyboardShortcut("-")

            Button {
                fontSize = min(2000, fontSize + 10)
            } label: {
                Label("Larger", systemImage: "plus")
            }.keyboardShortcut("=")
            Section("Favorites") {
                Button {
                    if myFavorites.contains(systemName) {
                        removeFavorite(symbols: systemName)
                    } else {
                        addFavorite(symbols: systemName)
                    }
                } label: {
                    if myFavorites.contains(systemName) {
                        Label("Unfavorite", systemImage: "star.fill")
                    } else {
                        Label("Favorite", systemImage: "star")
                    }
                }.keyboardShortcut("f")

                Button {
                    clearFavorites()
                } label: {
                    Label("Clear", systemImage: "star.slash")
                }.keyboardShortcut("f", modifiers: [.command, .shift])
            }
        }
        CommandGroup(replacing: .appInfo) {
            Button {
                appDelegate.showAboutPanel()
            } label: {
                Text("About \(NSApplication.appName ?? "SymbolView")")
            }
        }
/*
        CommandGroup(replacing: .help) {
            Button {
                appDelegate.showHelpPanel()
            } label: {
                Text("\(NSApplication.appName ?? "SymbolView") Help")
            }.keyboardShortcut("/", modifiers: [.command])
        }
 */
        CommandGroup(after: .help) {
            Section {
                Link("SF Symbols Info", destination: URL(string: "https://developer.apple.com/sf-symbols/")!)
                // swiftlint:disable line_length
                Link("Human Interface Guidlines", destination: URL(string: "https://developer.apple.com/design/human-interface-guidelines/sf-symbols")!)
                Link("Download SF Symbols 6 - beta", destination: URL(string: "https://devimages-cdn.apple.com/design/resources/download/SF-Symbols-6.dmg")!)
                // swiftlint:enable line_length
            }
        }
    }

    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @AppStorage("favorites") private var favorites: String = "[]"
    @AppStorage("showingSearch") var showingSearch = false
    @AppStorage("searchText") var searchText = ""
    @AppStorage("fontSize") var fontSize = 50.0
    @AppStorage("systemName") var systemName = ""

    func showSearch() { showingSearch.toggle() }

    func clearSearch() { showingSearch = false; searchText = "" }

    func clearFavorites() { favorites = "[]" }

    var myFavorites: [String] {
        get { Array(jsonString: favorites) ?? [] }
        set { favorites = newValue.jsonString() ?? "[]" }
    }
}
#endif
