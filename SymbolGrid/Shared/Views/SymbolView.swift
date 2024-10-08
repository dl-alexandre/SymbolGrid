//
//  SheetView.swift
//  SymbolGrid
//
//  Created by Dalton on 6/15/24.
//

import SwiftUI
import Design
import SFSymbolKit

struct SymbolView: View {
#if os(macOS)
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
#endif
    @Environment(\.verticalSizeClass) var verticalSizeClass

    @Binding var fontSize: Double
    @Binding var selectedWeight: Weight
    @Binding var selectedMode: SymbolRenderingModes
    @Binding var showingSymbolMenu: Bool
    @Binding var showingDetail: Bool
    @Binding var showingSearch: Bool
    @Binding var showingFavorites: Bool
    @Binding var searchText: String
    @Binding var searchScope: CategoryTokens
    @Binding var searchTokens: [SearchToken]
    var searchResults: [Symbol]
    var favoriteSuggestions: [Symbol]
    let handleSearch: () -> Void

    @State var isHovered = false
    @State private var vmo = ViewModel()

    var body: some View {
        let icons: [Symbol] = searchResults
        let suggestions: [Symbol] = favoriteSuggestions
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
                                                selectedMode: $renderMode,
                                                showInspector: $showInspector
                                            )
#endif
                                        }
                                    } label: {
                                        Image(systemName: icon.name)
                                            .symbolRenderingMode(selectedMode.mode)
                                            .font(.system(size: fontSize, weight: selectedWeight.weight))
                                            .animation(.linear, value: 0.5)
                                            .opacity(isHovered ? 0.5 : 1.0)
#if os(iOS)
                                            .hoverEffect(.highlight)
#endif
                                            .onHover { hovering in
                                                isHovered = hovering
                                            }
                                            .previewLayout(.sizeThatFits)
                                        .padding(8)
                                        .contentShape(.dragPreview, RoundedRectangle(cornerRadius: 7))
                                        .foregroundStyle((vmo.selected == icon) ? Color.random() : .primary)
                                        .draggable(Image(systemName: icon.name)) {
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
                        tokens: $searchTokens,
                        isPresented: $showingSearch,
                        prompt: Text("Search Symbols"),
                        token: { token in
                        Text(token.text)
                    })
                    .onSubmit(of: .search, {
                        handleSearch()
                    })
                    .searchSuggestions {
                        if !suggestions.isEmpty {
                            ForEach(suggestions, id: \.self) { suggestion in
                                Button {
                                    searchText = suggestion.name
                                } label: {
                                    Label(suggestion.name, systemImage: suggestion.name)
                                }
                            }
                        }
                    }
                    .searchScopes($searchScope, activation: .onSearchPresentation) {
                        Text("\(CategoryTokens.all.label)")
                            .tag(CategoryTokens.all)
                        Text("\(CategoryTokens.multicolor.label)")
                            .tag(CategoryTokens.multicolor)
                        Text("\(CategoryTokens.variablecolor.label)")
                            .tag(CategoryTokens.variablecolor)
                    }
                }
                .refreshable {
                    showingSymbolMenu.toggle()
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
                            selectedMode: $selectedMode,
                            showingDetail: $showingDetail,
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
                        showingDetail: $showingDetail,
                        showingSearch: $showingSearch,
                        searchText: $searchText
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
}

#Preview {
    SymbolView(
        fontSize: .constant(50.0),
        selectedWeight: .constant(.regular),
        selectedMode: .constant(.monochrome),
        showingSymbolMenu: .constant(false),
        showingDetail: .constant(false),
        showingSearch: .constant(false),
        showingFavorites: .constant(false),
        searchText: .constant(""),
        searchScope: .constant(.all),
        searchTokens: .constant([]),
        searchResults: [],
        favoriteSuggestions: [],
        handleSearch: {}
    )
}
