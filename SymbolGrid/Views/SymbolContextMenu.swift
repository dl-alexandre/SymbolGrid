//
//  SymbolContextMenu.swift
//  SymbolView
//
//  Created by Dalton Alexandre on 5/24/24.
//

import SwiftUI
import UniformTypeIdentifiers

struct SymbolContextMenu: View {
    var body: some View {
        Section("Favorites") {
            if !self.favoritesBinding.wrappedValue.isEmpty {
                Button {
                    if tabModel.activeTab == .home {
                        tabModel.activeTab = .favorites
                    } else {
                        tabModel.activeTab = .home
                    }
                } label: {
                    Label("Show", systemImage: "line.horizontal.star.fill.line.horizontal")
                }/*.keyboardShortcut("f", modifiers: [])*/
            }
            
            Button {
                if self.favoritesBinding.wrappedValue.contains(icon) {
                    var updatedFavorites = self.favoritesBinding.wrappedValue
                    updatedFavorites.removeAll(where: { $0 == icon })
                    self.favoritesBinding.wrappedValue = updatedFavorites
                } else {
                    var updatedFavorites = self.favoritesBinding.wrappedValue
                    updatedFavorites.append(icon)
                    self.favoritesBinding.wrappedValue = updatedFavorites
                    
                }
            } label: {
                if self.favoritesBinding.wrappedValue.contains(icon) {
                    Label("Remove", systemImage: "star.fill")
                } else {
                    Label("Add", systemImage: "star")          
                }
            }/*.keyboardShortcut("a", modifiers: [])*/
        }
        
#if os(iOS)
        Button {
            UIPasteboard.general .setValue(icon.description,
                                           forPasteboardType: UTType.plainText .identifier)
        } label: {
            Label("Copy", systemImage: "doc.on.doc")
        }
        Section("Size") {
            Stepper(value: $fontSize, in: 9...200, step: 5) {
                EmptyView()
            }
            .onChange(of: fontSize) { oldValue, newValue in
                fontSize = min(max(newValue, 9), 200)
            }
        }
        
#endif
        Button {
            showingWeight.toggle()
        } label: {
            Label("Weight", systemImage: "arrowtriangle.left.and.line.vertical.and.arrowtriangle.right.fill")
        }
        Button {
            showingRender.toggle()
        } label: {
            Label("Render", systemImage: "paintbrush")
        }
        Button {
            showingSearch.toggle()
        } label: {
            Label("Search", systemImage: "magnifyingglass")
        }
    }
    
    @AppStorage("favorites") private var favorites: String = "[]"
    @AppStorage("showingSearch") var showingSearch = true
    @AppStorage("showingRender") var showingRender = true
    @AppStorage("showingWeight") var showingWeight = true
    @AppStorage("showingCanvas") var showingCanvas = false
    @AppStorage("canvasIcon") var canvasIcon = ""
    @AppStorage("fontSize") var fontSize = 50.0
    //@AppStorage("tab") var selectedTab = 0
    @EnvironmentObject private var tabModel: TabModel
    
    var icon: String
    
    var favoritesBinding: Binding<[String]> {
        Binding(
            get: { Array(jsonString: self.favorites) ?? [] },
            set: { self.favorites = $0.jsonString() ?? "[]" }
        )
    }
     
}

#Preview {
    SymbolContextMenu(icon: "doc.on.doc"/*, tabs: Tab.home*/)
}

