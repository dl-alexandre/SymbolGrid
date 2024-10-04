//
//  Commands.swift
//  SymbolGrid
//
//  Created by Dalton Alexandre on 5/31/24.
//

import SwiftUI
import SwiftData
#if os(macOS)
struct SymbolCommands: Commands {
    var body: some Commands {
        SidebarCommands()
        CommandMenu("Symbols") {
            Button {
                system.showSearch()
            } label: {
                Label("Search", systemImage: "magnifyingglass")
            }.keyboardShortcut("s")
            Button {
                system.clearSearch()
            } label: {
                Label("Clear", systemImage: "delete.left")
            }.keyboardShortcut(.escape, modifiers: [])

            Button {
                system.fontSize = max(9, system.fontSize - 5)
            } label: {
                Label("Smaller", systemImage: "minus")
            }.keyboardShortcut("-")

            Button {
                system.fontSize = min(2000, system.fontSize + 10)
            } label: {
                Label("Larger", systemImage: "plus")
            }.keyboardShortcut("=")
            Section("Favorites") {
                Button {
                    system.showInspector.toggle()
                } label: {
                    Label("Show", systemImage: "sparkle")
                }.keyboardShortcut("f", modifiers: [])

                Button {
                    if system.myFavorites.contains(system.systemName) {
                        removeFavorite(symbols: system.systemName)
                    } else {
                        addFavorite(symbols: system.systemName)
                    }
                } label: {
                    if system.myFavorites.contains(system.systemName) {
                        Label("Unfavorite", systemImage: "star.fill")
                    } else {
                        Label("Favorite", systemImage: "star")
                    }
                }.keyboardShortcut("f")

                Button {
                    system.clearFavorites()
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
                Link(
                    "Human Interface Guidlines",
                    destination: URL(
                        string: "https://developer.apple.com/design/human-interface-guidelines/sf-symbols"
                    )!
                )
                Link(
                    "Download SF Symbols 6",
                    destination: URL(
                        string: "https://devimages-cdn.apple.com/design/resources/download/SF-Symbols-6.dmg"
                    )!
                )
            }
        }
    }

    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @Environment(\.modelContext) private var moc
    @State private var system = System()

    var myFavorites: [String] {
        get { Array(jsonString: system.favorites) ?? [] }
        set { system.favorites = newValue.jsonString() ?? "[]" }
    }
}
#endif
