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
//                Button {
//                    showFavorites()
//                } label: {
//                    Label("View", systemImage: "star.slash")
//                }.keyboardShortcut("f", modifiers: [])
//                
                Button {
                    if myFavorites.contains(icon) {
                        removeFavorite(icons: icon)
                    } else {
                        addFavorite(icons: icon)
                    }
                } label: {
                    if myFavorites.contains(icon) {
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
        CommandGroup(replacing: CommandGroupPlacement.appInfo) {
            Button(action: {
                appDelegate.showAboutPanel()
            }) {
                Text("About \(NSApplication.appName ?? "SymbolView")")
            }
        }
    }
    
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @AppStorage("favorites") private var favorites: String = "[]"
    @AppStorage("showingSearch") var showingSearch = false
    @AppStorage("searchText") var searchText = ""
    @AppStorage("icon") var icon = ""
    @AppStorage("fontSize") var fontSize = 50.0
//    @AppStorage("tab") var selectedTab = 0
//    @EnvironmentObject private var tabModel: TabModel
    
    func showSearch() { showingSearch.toggle() }
    
    func clearSearch() { showingSearch = false; searchText = "" }
    
    func clearFavorites() { favorites = "[]" }
    
//    func showFavorites() { if tabModel.activeTab == .home {
//        tabModel.activeTab = .favorites
//    } else {
//        tabModel.activeTab = .home
//    } }
    
    var myFavorites: [String] {
        get { Array(jsonString: favorites) ?? [] }
        set { favorites = newValue.jsonString() ?? "[]" }
    }
}
#endif
