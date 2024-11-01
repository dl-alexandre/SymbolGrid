//
//  Favorites.swift
//  SymbolView
//
//  Created by Dalton Alexandre on 5/30/24.
//

import SwiftUI
import Design
import SFSymbolKit
import SwiftData
import UniformTypeIdentifiers

struct FavoritesView: View {
    @Environment(\.modelContext) private var moc
    @State private var vmo = ViewModel()
    @Query var favorites: [Favorite]
    @Binding var fontSize: Double
    @Binding var showingDetail: Bool
    @Binding var showingSearch: Bool
    @Binding var searchText: String
    @State private var hasIndexedSymbols: Bool = false

    var body: some View {
        ZStack {
            if favorites.isEmpty {
                ContentUnavailableView {
                    Label("No Favorites", systemImage: "star.slash")
                } description: {
                    Text("Find your favorite symbols here")
                    Button {
                        vmo.showFavorites()
                    } label: {
                        Label("Show", systemImage: "line.horizontal.star.fill.line.horizontal")
                    }
                }
            } else {
                List {
                    ForEach(0..<favorites.count, id: \.self) { index in
                        let favorite = favorites[index]
                        Label(favorite.glyph, systemImage: favorite.glyph)
                            .accessibilityIdentifier("favoriteRow-\(index)")
                            .foregroundColor(
                                vmo.systemName == favorite.glyph ? Color.secondary : Color.primary
                            )
                            .onTapGesture(count: 2) {
                                withAnimation(.spring()) {
                                    vmo.copy()
                                }
#if os(macOS)
                                NSPasteboard.general.setString(vmo.systemName, forType: .string)
#else
                                UIPasteboard.general .setValue(
                                    vmo.systemName.description,
                                    forPasteboardType: UTType.plainText .identifier
                                )
#endif
                            }
                            .onDrag {
#if os(macOS)
                                let provider = NSItemProvider(
                                    object: (
                                        Image(systemName: favorite.glyph)
                                            .asNSImage() ?? Image(systemName: "plus")
                                            .asNSImage()!
                                    ) as NSImage
                                )
#else
                                let provider = NSItemProvider(
                                    object: (
                                        UIImage(
                                            systemName: favorite.glyph
                                        ) ?? UIImage(systemName: "plus")!
                                    )
                                )
#endif
                                return provider
                            }
                            .contextMenu {
                                Section("Symbol") {
                                    Button {
                                        let symbol = Symbol(name: favorite.glyph)
                                        vmo.selected = symbol
                                        vmo.showDetail()
                                    } label: {
                                        Label("View", systemImage: "drop.halffull")
                                    }

                                }
                                Button {
#if os(iOS)
                                    UIPasteboard.general .setValue(
                                        favorite.glyph.description,
                                        forPasteboardType: UTType.plainText .identifier
                                    )
#else
                                    let pasteboard = NSPasteboard.general
                                    pasteboard.declareTypes([.string], owner: nil)
                                    pasteboard.setString(favorite.glyph.description, forType: .string)
#endif
                                } label: {
                                    Label("Copy", systemImage: "doc.on.doc")
                                }
                                Button {
                                    searchText =  favorite.glyph
                                    showingSearch = true
                                } label: {
                                    Label("Search", systemImage: "magnifyingglass")
                                }
                            } preview: {
                                Group {
                                    Image(systemName: favorite.glyph)
                                        .foregroundColor(.primary)
                                    Text(favorite.glyph)
                                }.padding()
                            }
                            .draggable("\(favorite.glyph)") {
                                Image(systemName: "\(favorite.glyph)")
                            }
                            .swipeActions(edge: .leading, allowsFullSwipe: true) {
                                Button(role: .destructive) {
                                    deleteFavorite(glyph: favorite, modelContext: moc)
                                    removeIndex(favorite.glyph, "com.alexandrefamilyfarm.symbols")
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }.accessibilityIdentifier("removeFavorite-\(index)")

                            }
                    }
                }
                //                .dropDestination(for: String.self) { items, location in
                //                    if let item = items.first {
                //                        draggedText = item
                //                        print("\(draggedText) added to favorites")
                //                        addFavorite(symbols: draggedText)
                //                        return true
                //                    }
                //                    return false
                //                }
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        copyNotification(isCopied: $vmo.isCopied, icon: $vmo.systemName)
                    }
                }
#if os(iOS)
                .sheet(isPresented: $vmo.showingDetail) {
                    if let selected = vmo.selected {
                        DetailView(
                            icon: selected,
                            fontSize: $fontSize,
                            showingDetail: $vmo.showingDetail
                        )
                        .presentationDetents([.large])
                    }
                }
#endif
            }
        }
#if os(iOS)
        .hoverEffect(.highlight)
#endif
        .onAppear {
            addIndex("com.alexandrefamilyfarm.symbols", Set(favorites.map {$0.glyph}))
        }
        .edgesIgnoringSafeArea(.all)
        //        .dropDestination(for: String.self) { items, location in
        //            if let item = items.first {
        //                draggedText = item
        //                print("\(draggedText) added to favorites")
        //                addFavorite(symbols: draggedText)
        //                return true
        //            }
        //            return false
        //        }
    }
}
