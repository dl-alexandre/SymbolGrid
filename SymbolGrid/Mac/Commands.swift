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
//                vmo.showSearch()
            } label: {
                Label("Search", systemImage: "magnifyingglass")
            }.keyboardShortcut("s")
            Button {
//                system.clearSearch()
            } label: {
                Label("Clear", systemImage: "delete.left")
            }.keyboardShortcut(.escape, modifiers: [])

            Button {
//                $vmo.fontSize = max(9, $vmo.fontSize - 5)
            } label: {
                Label("Smaller", systemImage: "minus")
            }.keyboardShortcut("-")

            Button {
//                vmo.fontSize = min(2000, system.fontSize + 10)
            } label: {
                Label("Larger", systemImage: "plus")
            }.keyboardShortcut("=")
            Section("Favorites") {
                Button {
                    vmo.showFavorites()
                } label: {
                    Label("Show", systemImage: "sparkle")
                }.keyboardShortcut("f", modifiers: [])

                Button {
                    if favorites.contains(where: { $0.glyph == vmo.selected?.name }) {
                        if let favoriteToDelete = favorites.first(where: { $0.glyph == vmo.selected?.name }) {
                            deleteFavorite(glyph: favoriteToDelete, modelContext: moc)
                        }
                    } else {
                        if let favoriteToAdd = vmo.selected {
                            addFavorite(glyph: favoriteToAdd.name, modelContext: moc, favorites: favorites)
                        }
                    }
                } label: {
                    if favorites.contains(where: { $0.glyph == vmo.selected?.name }) {
                        Label("Unfavorite", systemImage: "star.fill")
                    } else {
                        Label("Favorite", systemImage: "star")
                    }
                }.keyboardShortcut("f")

                Button {
                    clearFavorites(favorites: favorites, modelContext: moc)
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
    @Query var favorites: [Favorite]
    @State private var localizations = Localizations()
    @State private var vmo = ViewModel()
}
#endif
