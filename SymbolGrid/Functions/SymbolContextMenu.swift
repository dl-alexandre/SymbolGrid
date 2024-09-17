//
//  SymbolContextMenu.swift
//  SymbolGrid
//
//  Created by Dalton on 6/18/24.
//

import SwiftUI
import UniformTypeIdentifiers

private func favoritingSymbol(
    _ favoritesBinding: Binding<[String]>,
    _ tabModel: TabModel,
    _ icon: Icon
) -> Section<
    Text,
    TupleView<(
        Button<Label<
        Text,
        Image
        >>?,
        Button<_ConditionalContent<
        Label<
        Text,
        Image
        >,
        Label<Text, Image>
        >>
    )>,
    EmptyView
> {
    return Section("Favorites") {
        if favoritesBinding.wrappedValue.isEmpty {
            Button {
                if tabModel.activeTab == .home {
                    tabModel.activeTab = .favorites
                } else {
                    tabModel.activeTab = .home
                }
            } label: {
                Label("Show", systemImage: "line.horizontal.star.fill.line.horizontal")
            }
        }

        Button {
            if favoritesBinding.wrappedValue.contains(icon.id) {
                removeFavorite(symbols: icon.id)
            } else {
                addFavorite(symbols: icon.id)
            }
        } label: {
            if favoritesBinding.wrappedValue.contains(icon.id) {
                Label("Remove", systemImage: "star.fill")
            } else {
                Label("Add", systemImage: "star")
            }
        }
    }
}

private func copySymbol(_ icon: Icon) -> Button<Label<Text, Image>> {
    return Button {
#if os(iOS)
        UIPasteboard.general .setValue(
            icon.id.description,
            forPasteboardType: UTType.plainText .identifier
        )
#else
            let pasteboard = NSPasteboard.general
            pasteboard.declareTypes([.string], owner: nil)
            pasteboard.setString(icon.id.description, forType: .string)
#endif
    } label: {
        Label("Copy", systemImage: "doc.on.doc")
    }
}

@ViewBuilder
func symbolContextMenu(
    icon: Icon,
    selected: Binding<Icon?>,
    tabModel: TabModel
) -> some View {
    @AppStorage("favorites") var favorites: String = "[]"
    @AppStorage("showingSearch") var showingSearch = true
    @AppStorage("fontSize") var fontSize = 50.0

    var favoritesBinding: Binding<[String]> {
        Binding(
            get: { Array(jsonString: favorites) ?? [] },
            set: { favorites = $0.jsonString() ?? "[]" }
        )
    }

#if os(iOS)
    Section("Symbol") {
        Button {
            selected.wrappedValue = icon
        } label: {
            Label("View", systemImage: "drop.halffull")
        }
    }
#endif
    favoritingSymbol(favoritesBinding, tabModel, icon)
#if os(iOS)
    copySymbol(icon)
    Button {
        showingSearch.toggle()
    } label: {
        Label("Search", systemImage: "magnifyingglass")
    }
#endif
}
