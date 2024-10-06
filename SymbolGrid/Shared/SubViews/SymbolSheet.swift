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
    @State private var sys = System()

    var icon: String
    @Environment(\.modelContext) private var moc
    @Query private var favorites: [Favorite]

    @Binding var detailIcon: String?
    @Binding var fontSize: Double
    @Binding var searchText: String
    @Binding var selectedWeight: Weight
    @Binding var selectedSample: SymbolRenderingModes
    @Binding var showingSearch: Bool
    var favoriteSuggestions: [String]
#if os(macOS)
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
#endif
    var body: some View {

        VStack {
            Button {
                vmo.detailIcon = icon
                vmo.showDetail()
            } label: {
                Label("\(icon)", systemImage: "\(icon)")
            }
            .buttonStyle(BorderedProminentButtonStyle())
            HStack {
                Button {
                    withAnimation(.spring()) {
                        vmo.copy()
                    }
#if os(iOS)
                    UIPasteboard.general .setValue(icon.description,
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
                    if favorites.contains(where: { $0.glyph == icon }) {
                        let favoriteToDelete = favorites.first(where: { $0.glyph == icon })
//                        removeFavorite(symbols: icon.id)
                        if let favorite = favoriteToDelete {
                            deleteFavorite(glyph: favorite, modelContext: moc)
                        }
                    } else {
//                        addFavorite(symbols: icon.id)
                        addFavorite(glyph: icon, modelContext: moc)
                    }
                } label: {
                    if favorites.contains(where: { $0.glyph == icon }) {
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
            //            .buttonStyle(BorderedProminentButtonStyle())
            //            .background(.ultraThinMaterial)
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
        .inspector(isPresented: $showDetail) {
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
                showingSearch: $showingSearch,
                searchText: $searchText,
                favoriteSuggestions: favoriteSuggestions
            )
        }
    }
}

#if os(iOS)
#Preview {
    SymbolSheet(
        icon: "square",
        detailIcon: .constant("square"),
        fontSize: .constant(50.0),
        searchText: .constant(""),
        selectedWeight: .constant(Weight.regular),
        selectedSample: .constant(SymbolRenderingModes.monochrome),
        showingSearch: .constant(false),
        favoriteSuggestions: [""]
    )
}
#endif
