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

//    @Namespace var animation
    @Binding var fontSize: Double
    @Binding var selectedWeight: Weight
    @Binding var selectedSample: SymbolRenderingModes
    @Binding var showingSymbolMenu: Bool
    @Binding var showingSearch: Bool
    @Binding var showingFavorites: Bool
    @Binding var searchText: String
    var searchResults: [String]
    var favoriteSuggestions: [String]
    @Environment(\.verticalSizeClass) var verticalSizeClass

    @State private var sys = System()
    @State private var vmo = ViewModel()

    var body: some View {
        let icons: [String] = searchResults.map { symbolName in
             symbolName
        }

        let suggestions: [String] = favoriteSuggestions.map { symbolName in
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
                            LazyVGrid(columns: columns, spacing: fontSize * 0.1) {
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
                        text: $searchText,
                        isPresented: $showingSearch,
                        prompt: Text("Search Symbols")
                    )
                    .searchSuggestions {
                        if !suggestions.isEmpty {
                            ForEach(suggestions, id: \.self) { suggestion in
                                Button {
                                    searchText = suggestion
                                } label: {
                                    Label(suggestion, systemImage: suggestion)
                                }
                            }
                        }
                    }
//                    .searchScopes(["Symbols"])
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
                            searchText: $searchText,
                            selectedWeight: $selectedWeight,
                            selectedSample: $selectedSample,
                            showingSearch: $showingSearch,
                            favoriteSuggestions: favoriteSuggestions
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
                    FavoritesView(
                        fontSize: $fontSize,
                        showingSearch: $showingSearch,
                        searchText: $searchText,
                        favoriteSuggestions: favoriteSuggestions
                    )
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
//    @State var draggedText = ""
}

#Preview {
    SymbolView(
        fontSize: .constant(50.0),
        selectedWeight: .constant(.regular),
        selectedSample: .constant(.monochrome),
        showingSymbolMenu: .constant(false),
        showingSearch: .constant(false),
        showingFavorites: .constant(false),
        searchText: .constant(""),
        searchResults: [""],
        favoriteSuggestions: [""]
    )
}
