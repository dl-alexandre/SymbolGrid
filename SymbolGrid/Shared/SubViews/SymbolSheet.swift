//
//  MenuSheet.swift
//  SymbolGrid
//
//  Created by Dalton Alexandre on 9/10/24.
//

import SwiftUI
import SwiftData
import Design
import SFSymbolKit
import UniformTypeIdentifiers

struct SymbolSheet: View {
    @Environment(\.dismiss) var dismiss
    @State private var vmo = ViewModel()

    var icon: Symbol
    @Environment(\.modelContext) private var moc
    @Query private var favorites: [Favorite]

    @Binding var detailIcon: Symbol?
    @Binding var fontSize: Double
    @Binding var searchText: String
    @Binding var selectedWeight: Weight
    @Binding var selectedMode: SymbolRenderingModes
    @Binding var showingDetail: Bool
    @Binding var showingSearch: Bool

#if os(macOS)
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
#endif
    var body: some View {

        VStack {
            Button {
                vmo.detailIcon = icon
                vmo.showDetail()
            } label: {
                Label(icon.name, systemImage: icon.name)
            }
            .buttonStyle(BorderedProminentButtonStyle())
            HStack {
                Button {
                    withAnimation(.spring()) {
                        vmo.copy()
                    }
#if os(iOS)
                    UIPasteboard.general .setValue(icon.name,
                                                   forPasteboardType: UTType.plainText .identifier)
#else
                    let pasteboard = NSPasteboard.general
                    pasteboard.declareTypes([.string], owner: nil)
                    pasteboard.setString(icon.id.description, forType: .string)
#endif
                } label: {
                    Image(systemName: "doc.on.doc").padding()
                }
                Button {
                    if favorites.contains(where: { $0.glyph == icon.name }) {
                        let favoriteToDelete = favorites.first(where: { $0.glyph == icon.name })
                        if let favorite = favoriteToDelete {
                            deleteFavorite(glyph: favorite, modelContext: moc)
                        }
                    } else {
                        addFavorite(glyph: icon.name, modelContext: moc, favorites: favorites)
                    }
                } label: {
                    if favorites.contains(where: { $0.glyph == icon.name }) {
                        Label("", systemImage: "star.fill").padding()
                            .foregroundStyle(.yellow)
                    } else {
                        Image(systemName: "star").padding()
                    }
                }
                Button {
                    withAnimation {
                        vmo.showFavorites()
                    }
                } label: {
                    if !favorites.isEmpty {
                        Image(systemName: "sparkles").padding()
                    }
                }
            }
            .buttonStyle(PlainButtonStyle())
            .font(.system(size: fontSize))
            copyNotification(isCopied: $vmo.isCopied, icon: $vmo.systemName)
//                .dropDestination(for: String.self) { items, _ in
//                    if let item = items.first {
//                        draggedText = item
//                        print("\(draggedText) added to favorites")
//                        addFavorite(symbols: draggedText)
//                        return true
//                    }
//                    return false
//                }
//           }
        }
#if os(macOS)
        .inspector(isPresented: $showingDetail) {
            DetailView(icon: icon)
                .inspectorColumnWidth(min: 300, ideal: 500, max: 1000)
        }
#else
        .sheet(isPresented: $vmo.showingDetail) {
            DetailView(
                icon: icon,
                fontSize: $fontSize,
                showingDetail: $vmo.showingDetail
            )
                .presentationDetents([.large])
        }
#endif
        .inspector(isPresented: $vmo.showingFavorites) {
            FavoritesView(
                fontSize: $fontSize,
                showingDetail: $showingDetail,
                showingSearch: $showingSearch,
                searchText: $searchText
            )
        }
    }
}

#if os(iOS)
#Preview {
    let math = CategoryTokens.math
    let category = SymbolCategory(icon: math.icon, key: math.key, label: math.label)
    let symbol = Symbol(name: "plus", categories: [category])

    SymbolSheet(
        icon: symbol,
        detailIcon: .constant(symbol),
        fontSize: .constant(50.0),
        searchText: .constant(""),
        selectedWeight: .constant(Weight.regular),
        selectedMode: .constant(SymbolRenderingModes.monochrome),
        showingDetail: .constant(false),
        showingSearch: .constant(false)
    )
}
#endif
