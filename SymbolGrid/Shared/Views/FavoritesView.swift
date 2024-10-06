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

struct FavoritesView: View {
    @Environment(\.modelContext) private var moc
    @State private var sys = System()
    @State private var vmo = ViewModel()
    @Query var favorites: [Favorite]
    @Binding var fontSize: Double
    @Binding var showingSearch: Bool
    @Binding var searchText: String
    var favoriteSuggestions: [String]

    var body: some View {
        let icons: [String] = favoriteSuggestions.map { symbolName in
            symbolName
        }

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
                    ForEach(favorites, id: \.glyph) { fav in
                        favorite(
                            icon: fav.glyph,
                            fontSize: fontSize,
                            selected: $selected,
                            searchText: $searchText,
                            showingSearch: $showingSearch
                        )
                        .draggable("\(fav.glyph)") {
                            Image(systemName: "\(fav.glyph)")
                        }
                        .swipeActions(edge: .leading, allowsFullSwipe: true) {
                            Button(role: .destructive) {
                                deleteFavorite(glyph: fav, modelContext: moc)
//                                removeFavorite(symbols: ("\(fav.glyph)"))
                                removeIndex(fav.glyph, "com.alexandrefamilyfarm.symbols")
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
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
                        copyNotification(isCopied: $isCopied, icon: $vmo.systemName)
                    }
                }
#if os(iOS)
                .sheet(isPresented: $vmo.showingDetail) {
                    if let selected = vmo.selected {
                        DetailView(
                            icon: selected,
                            fontSize: $fontSize,
                            showingDetail: $vmo.showingDetail,
//                            animation: animation,
                            color: Color.random()
                        )
                        .presentationDetents([.medium])
                    }
                }
#endif
            }
        }
#if os(iOS)
        .hoverEffect(.highlight)
#endif
        .onAppear {
            for item in icons {
                addIndex(item, "com.alexandrefamilyfarm.symbols")
            }

//            showingTitle = true
//            DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
//                withAnimation(.easeInOut(duration: 2)) {
//                    showingTitle = false
//                }
//            }
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
    @State private var draggedText = ""
    @Namespace var animation
    @State private var selected: String?
    @State private var italic = false
    @State private var isCopied = false

//    var myFavorites: [String] {
//        get { Array(jsonString: favorites) ?? [] }
//        set { favorites = newValue.jsonString() ?? "[]" }
//    }
//
//    var searchResults: [String] {
//        return myFavorites.filter { key in
//
//            if !arabicSetting && key.hasSuffix(".ar") { return false }
//            if !bengaliSetting && key.hasSuffix(".bn") { return false }
//            if !burmeseSetting && key.hasSuffix(".my") { return false }
//            if !chineseSetting && key.hasSuffix(".zh") { return false }
//            if !gujaratiSetting && key.hasSuffix(".gu") { return false }
//            if !hebrewSetting && key.hasSuffix(".he") { return false }
//            if !hindiSetting && key.hasSuffix(".hi") { return false }
//            if !japaneseSetting && key.hasSuffix(".ja") { return false }
//            if !kannadaSetting && key.hasSuffix(".kn") { return false }
//            if !khmerSetting && key.hasSuffix(".km") { return false }
//            if !koreanSetting && key.hasSuffix(".ko") { return false }
//            if !latinSetting && key.hasSuffix(".el") { return false }
//            if !malayalamSetting && key.hasSuffix(".ml") { return false }
//            if !manipuriSetting && key.hasSuffix(".mni") { return false }
//            if !marathiSetting && key.hasSuffix(".mr") { return false }
//            if !oriyaSetting && key.hasSuffix(".or") { return false }
//            if !russianSetting && key.hasSuffix(".ru") { return false }
//            if !santaliSetting && key.hasSuffix(".sat") { return false }
//            if !sinhalaSetting && key.hasSuffix(".si") { return false }
//            if !tamilSetting && key.hasSuffix(".ta") { return false }
//            if !teluguSetting && key.hasSuffix(".te") { return false }
//            if !thaiSetting && key.hasSuffix(".th") { return false }
//            if !punjabiSetting && key.hasSuffix(".pa") { return false }
//
//            // Apply search text filter if searchText is not empty
//            if !searchText.isEmpty { return key.contains(searchText.lowercased()) }
//            return true // Include the key if none of the above conditions are met and searchText is empty
//        }
//    }
//
//    private var columns: [GridItem] {
//        [GridItem(.flexible())]
//    }
//
//    private var spacing: CGFloat {
//        fontSize * 0.1
//    }
}
