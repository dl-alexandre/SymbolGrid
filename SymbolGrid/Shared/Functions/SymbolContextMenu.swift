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
    _ showInspector: Binding<Bool>,
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
> { @State var system = System()
    return Section("Favorites") {
        if favoritesBinding.wrappedValue.isEmpty {
            Button {
                showInspector.wrappedValue = true
            } label: {
                Label("Show", systemImage: "sparkles.rectangle.stack")
            }
        }

        Button {
            if favoritesBinding.wrappedValue.contains(icon.id) {
//                removeFavorite(symbols: icon.id)
            } else {
//                addFavorite(symbols: icon.id)
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

private func copySymbol(_ icon: String) -> Button<Label<Text, Image>> {
    return Button {
#if os(iOS)
        UIPasteboard.general .setValue(
            icon.description,
            forPasteboardType: UTType.plainText .identifier
        )
#else
            let pasteboard = NSPasteboard.general
            pasteboard.declareTypes([.string], owner: nil)
            pasteboard.setString(icon.description, forType: .string)
#endif
    } label: {
        Label("Copy", systemImage: "doc.on.doc")
    }
}

@ViewBuilder
func symbolContextMenu(
    icon: String,
    selected: Binding<String?>,
    searchText: Binding<String>,
    showingSearch: Binding<Bool>
) -> some View {

//    var favoritesBinding: Binding<[String]> {
//        Binding(
//            get: { Array(jsonString: sys.favorites) ?? [] },
//            set: { sys.favorites = $0.jsonString() ?? "[]" }
//        )
//    }

    @State var vmo = ViewModel()
    @State var sys = System()

#if os(iOS)
    Section("Symbol") {
        Button {
            selected.wrappedValue = icon
//            vmo.showDetail()
        } label: {
            Label("View", systemImage: "drop.halffull")
        }
    }
#endif
//    Section("Favorites") {
//        if favoritesBinding.wrappedValue.isEmpty {
//            Button {
//                vmo.showingFavorites = true
//            } label: {
//                Label("Show", systemImage: "sparkles.rectangle.stack")
//            }
//        }

//        Button {
//            if favoritesBinding.wrappedValue.contains(icon.id) {
//                removeFavorite(symbols: icon.id)
//            } else {
//                addFavorite(symbols: icon.id)
//
//            }
//        } label: {
//            if favoritesBinding.wrappedValue.contains(icon.id) {
//                Label("Remove", systemImage: "star.fill")
//            } else {
//                Label("Add", systemImage: "star")
//            }
//        }
//    }
//    favoritingSymbol(favoritesBinding, $vmo.showingFavorites, icon)
#if os(iOS)
    copySymbol(icon)
    Button {
        searchText.wrappedValue =  icon
        showingSearch.wrappedValue = true
    } label: {
        Label("Search", systemImage: "magnifyingglass")
    }
#endif
}
