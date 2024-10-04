//
//  SheetView.swift
//  SymbolGrid
//
//  Created by Dalton on 6/15/24.
//

import SwiftUI
import Design
import SFSymbolKit
import SwiftData
import UniformTypeIdentifiers

struct SymbolView: View {
#if os(macOS)
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
#endif

    @Namespace var animation
    @Binding var fontSize: Double
    @Binding var selectedWeight: Weight
    @Binding var selectedSample: SymbolRenderingModes
    @Binding var showingSymbolMenu: Bool
    @Binding var showingSearch: Bool
    @Binding var showingFavorites: Bool
    @Environment(\.verticalSizeClass) var verticalSizeClass
    @Environment(\.modelContext) var moc
    @State private var sys = System()
    @State private var vmo = ViewModel()
    @Query var favorites: [Favorite]

    var favoritesSuggestions: [String] {
        return favorites.map { $0.glyph }.filter { key in

            if !sys.arabicSetting && key.hasSuffix(".ar") { return false }
            if !sys.bengaliSetting && key.hasSuffix(".bn") { return false }
            if !sys.burmeseSetting && key.hasSuffix(".my") { return false }
            if !sys.chineseSetting && key.hasSuffix(".zh") { return false }
            if !sys.gujaratiSetting && key.hasSuffix(".gu") { return false }
            if !sys.hebrewSetting && key.hasSuffix(".he") { return false }
            if !sys.hindiSetting && key.hasSuffix(".hi") { return false }
            if !sys.japaneseSetting && key.hasSuffix(".ja") { return false }
            if !sys.kannadaSetting && key.hasSuffix(".kn") { return false }
            if !sys.khmerSetting && key.hasSuffix(".km") { return false }
            if !sys.koreanSetting && key.hasSuffix(".ko") { return false }
            if !sys.latinSetting && key.hasSuffix(".el") { return false }
            if !sys.malayalamSetting && key.hasSuffix(".ml") { return false }
            if !sys.manipuriSetting && key.hasSuffix(".mni") { return false }
            if !sys.marathiSetting && key.hasSuffix(".mr") { return false }
            if !sys.oriyaSetting && key.hasSuffix(".or") { return false }
            if !sys.russianSetting && key.hasSuffix(".ru") { return false }
            if !sys.santaliSetting && key.hasSuffix(".sat") { return false }
            if !sys.sinhalaSetting && key.hasSuffix(".si") { return false }
            if !sys.tamilSetting && key.hasSuffix(".ta") { return false }
            if !sys.teluguSetting && key.hasSuffix(".te") { return false }
            if !sys.thaiSetting && key.hasSuffix(".th") { return false }
            if !sys.punjabiSetting && key.hasSuffix(".pa") { return false }

            // Apply search text filter if searchText is not empty
            if !sys.searchText.isEmpty { return key.contains(sys.searchText.lowercased()) }
            return true // Include the key if none of the above conditions are met and searchText is empty
        }
    }

    var body: some View {
        let icons: [String] = sys.searchResults.map { symbolName in
             symbolName
        }

        let suggestions: [String] = favoritesSuggestions.map { symbolName in
            symbolName
        }

        ZStack {
            GeometryReader { geo in
                let minColumnWidth = 1.5 * fontSize
                let numberOfColumns = max(1, Int(geo.size.width / minColumnWidth))
                let columns = Array(
                    repeating: GridItem(
                        .adaptive(minimum: minColumnWidth)
                    ),
                    count: numberOfColumns
                )

                NavigationView {
                    ScrollViewReader { proxy in
                        ScrollView {
                            LazyVGrid(columns: columns, spacing: vmo.spacing) {
                                ForEach(icons, id: \.self) { icon in
                                    Button {
                                        if vmo.selected == icon {
                                            vmo.showSheet()
                                        } else {
                                            vmo.selected = icon
#if os(iOS)
                                            vmo.showingSheet = true
#else
                                            appDelegate.showMenuPanel(
                                                icon: icon,
                                                detailIcon: $detailIcon,
                                                selectedWeight: $fontWeight,
                                                selectedSample: $renderMode,
                                                showInspector: $showInspector
                                            )
#endif
                                        }
                                    } label: {
                                        symbol(
                                            icon: icon, fontSize: $fontSize,
                                            renderMode: $selectedSample,
                                            fontWeight: $selectedWeight
                                        )
                                        .padding(8)
//                                        .matchedTransitionSource(id: icon, in: animation)
                                        .contentShape(.dragPreview, RoundedRectangle(cornerRadius: 7))
                                        .foregroundStyle((vmo.selected == icon) ? Color.random() : .primary)
                                        .draggable(Image(systemName: icon)) {
                                            Text("\(icon)")
                                        }
                                    }.buttonStyle(BorderlessButtonStyle())
                                }
                            }
                        }
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                if icons.count > numberOfColumns {
                                    proxy.scrollTo(icons[numberOfColumns + 1], anchor: .top)
                                }
                            }
                        }
                    }
                    .searchable(
                        text: $sys.searchText,
                        isPresented: $showingSearch,
                        prompt: Text("Search Symbols")
                    )
                    .searchSuggestions {
                        if !suggestions.isEmpty {
                            ForEach(suggestions, id: \.self) { suggestion in
                                Button {
                                    sys.searchText = suggestion
                                } label: {
                                    Label(suggestion, systemImage: suggestion)
                                }
                            }
                        }
                    }
                }
//                .dropDestination(for: String.self) { items, _ in
//                    if let item = items.first {
////                        removeFavorite(symbols: item)
//
//                        deleteFavorite(glyph: , modelContext: moc)
//                        print("\(item) removed from favorites")
//                        return true
//                    }
//                    return false
//                }
                .refreshable {
//                    withAnimation {
                    showingSymbolMenu.toggle()
                        print("refreshed")
//                    }
                }
#if os(iOS)
                .sheet(isPresented: $vmo.showingSheet) {
                    if let selectedIcon = vmo.selected {
                        SymbolSheet(
                            icon: selectedIcon,
                            detailIcon: $vmo.detailIcon,
                            fontSize: $fontSize,
                            selectedWeight: $selectedWeight,
                            selectedSample: $selectedSample,
                            showingSearch: $showingSearch
                        )
                            .presentationBackgroundInteraction(.enabled)
                            .presentationDetents(
                                showingSearch ? [.medium] : [.height(geo.size.height / 4), .medium]
                            )
                            .sheet(isPresented: $vmo.showingDetail) {
                                DetailView(
                                    icon: selectedIcon,
                                    fontSize: $fontSize,
                                    showingDetail: $vmo.showingDetail
                                )
                                    .presentationDetents([.medium])
                            }
                    }
                }
#endif
                .inspector(isPresented: $showingFavorites) {
                    FavoritesView(fontSize: $fontSize, showingSearch: $showingSearch)
//                    .dropDestination(for: String.self) { items, _ in
//                        if let item = items.first {
//                            draggedText = item
//                            print("\(draggedText) added to favorites")
//                            addFavorite(glyph: <#T##Icon#>: draggedText)
//                            return true
//                        }
//                        return false
//                    }
                }
            }
        }

#if os(macOS)
        .toolbar {
            ToolbarItem(placement: .automatic) {
                if let selectedIcon = selected {
                    Text("\(selectedIcon.id)")
                        .padding()
                        .onTapGesture(count: 1) {
                            NSPasteboard.general.setString(selectedIcon.id, forType: .string)
                            print(selectedIcon.id)
                        }
                }
            }
        }
#endif
    }
    @State var draggedText = ""
}

#Preview {
    SymbolView(
        fontSize: .constant(50.0),
        selectedWeight: .constant(.regular),
        selectedSample: .constant(.monochrome),
        showingSymbolMenu: .constant(false),
        showingSearch: .constant(false),
        showingFavorites: .constant(false)
    )
}
