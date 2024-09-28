//
//  SheetView.swift
//  SymbolGrid
//
//  Created by Dalton on 6/15/24.
//

import SwiftUI
import Design
import SFSymbolKit
import UniformTypeIdentifiers

struct SymbolView: View {
    @EnvironmentObject private var tabModel: TabModel
#if os(macOS)
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
#endif
    var symbols: [String]

    var searchResults: [String] {
        return symbols.filter { key in
            if !arabicSetting && key.hasSuffix(".ar") { return false }
            if !bengaliSetting && key.hasSuffix(".bn") { return false }
            if !burmeseSetting && key.hasSuffix(".my") { return false }
            if !chineseSetting && key.hasSuffix(".zh") { return false }
            if !gujaratiSetting && key.hasSuffix(".gu") { return false }
            if !hebrewSetting && key.hasSuffix(".he") { return false }
            if !hindiSetting && key.hasSuffix(".hi") { return false }
            if !japaneseSetting && key.hasSuffix(".ja") { return false }
            if !kannadaSetting && key.hasSuffix(".kn") { return false }
            if !khmerSetting && key.hasSuffix(".km") { return false }
            if !koreanSetting && key.hasSuffix(".ko") { return false }
            if !latinSetting && key.hasSuffix(".el") { return false }
            if !malayalamSetting && key.hasSuffix(".ml") { return false }
            if !manipuriSetting && key.hasSuffix(".mni") { return false }
            if !oriyaSetting && key.hasSuffix(".or") { return false }
            if !russianSetting && key.hasSuffix(".ru") { return false }
            if !santaliSetting && key.hasSuffix(".sat") { return false }
            if !teluguSetting && key.hasSuffix(".te") { return false }
            if !thaiSetting && key.hasSuffix(".th") { return false }
            if !punjabiSetting && key.hasSuffix(".pa") { return false }

            // Apply search text filter if searchText is not empty
            if !searchText.isEmpty { return key.contains(searchText.lowercased()) }
            return true // Include the key if none of the above conditions are met and searchText is empty
        }
    }

    init(
        renderMode: Binding<RenderModes>,
        fontWeight: Binding<FontWeights>,
        symbols: [String]
    ) {
        self._renderMode = renderMode
        self._fontWeight = fontWeight
        self.symbols = symbols
    }

    private var columns: [GridItem] {
        [GridItem(.adaptive(minimum: 1.5 * fontSize))]
    }

    private var spacing: CGFloat {
        fontSize * 0.1
    }

    @Namespace var animation
    @State private var selected: Icon?
    @State private var detailIcon: Icon?
    @State private var isCopied = false

    @Binding public var renderMode: RenderModes
    @Binding public var fontWeight: FontWeights
    @AppStorage("isDragging") var isDragging = false
    @AppStorage("showWeightPicker") var showWeightPicker = false
    @FocusState public var isSearchFieldFocused: Bool
    @Environment(\.verticalSizeClass) var verticalSizeClass
//    @State private var position = ScrollPosition(edge: .top)

    @State private var selectedSample = RenderModes.monochrome
    @State private var selectedWeight = FontWeights.medium
    @AppStorage("showInspector") var showInspector = false
    @AppStorage("systemName") var systemName = ""
    @State private var showSheet = false

    var body: some View {
        let icons: [Icon] = searchResults.map { symbolName in
            Icon(id: symbolName, color: .random(), uiColor: .black)
        }

        ZStack {
            GeometryReader { geo in
                ScrollView {
                    LazyVGrid(columns: columns, spacing: spacing) {
                        ForEach(icons, id: \.id) { icon in
                            Button {
                                if selected?.id == icon.id {
                                    showSheet.toggle()
                                } else {
                                    selected = icon
#if os(iOS)
                                    showSheet = true
#else
                                    appDelegate.showMenuPanel(
                                        icon: icon,
                                        detailIcon: $detailIcon,
                                        selectedWeight: $fontWeight,
                                        selectedSample: $renderMode
                                    )
#endif
                                }
                            } label: {
                                symbol(
                                    icon: icon,
                                    renderMode: $renderMode,
                                    fontWeight: $fontWeight
                                )
                                .padding(8)
                                .matchedTransitionSource(id: icon.id, in: animation)
                                .contentShape(.dragPreview, RoundedRectangle(cornerRadius: 7))
                                .foregroundStyle((selected?.id == icon.id) ? icon.color : .primary)
//                                .draggable("\(icon.id)") {
//                                    Image(systemName: "\(icon.id)")
//                                }
//                                .draggable(Image(systemName: icon.id)) {
//                                    Image(systemName: "\(icon.id)")
//                                }
                                .draggable(Image(systemName: icon.id)) {
                                    Text("\(icon.id)")
                                }
                            }
                        }
                    }.offset(x: 0, y: searchText.isEmpty ? 0: (fontSize * 3))
                }
//                .overlay {
//                    FavoritesDrop()
//                        .opacity(isDragging ? 1 : 0)
//                }
                .dropDestination(for: String.self) { items, location in
                    if let item = items.first {
                        removeFavorite(symbols: item)
                        print("\(item) removed from favorites")
                        return true
                    }
                    return false
                }
                .refreshable {
                    withAnimation {
                        showWeightPicker.toggle()
                    }
                }
                .inspector(isPresented: $showInspector) {
                    FavoritesView(renderMode: $selectedSample, fontWeight: $selectedWeight)
//                        .inspectorColumnWidth(225)
                        .dropDestination(for: String.self) { items, location in
                            if let item = items.first {
                                draggedText = item
                                print("\(draggedText) added to favorites")
                                addFavorite(symbols: draggedText)
                                return true
                            }
                            return false
                        }
                }

//                .scrollPosition($position)
#if os(iOS)
                .sheet(isPresented: $showSheet) {
                    if let selectedIcon = selected {
                        SymbolSheet(
                            icon: selectedIcon,
                            detailIcon: $detailIcon,
                            selectedWeight: $fontWeight,
                            selectedSample: $renderMode,
                            showInspector: $showInspector
                        )
                            .presentationBackgroundInteraction(.enabled)
                            .presentationDetents([.height(geo.size.height / 4), .medium])
                            .sheet(item: $detailIcon) { icon in
                                DetailView(icon: icon, animation: animation, color: icon.color)
                                    .presentationDetents([.medium])
                            }
                    }
                }
#endif
            }
        }
//#if os(iOS)
//        .navigationBarTitleDisplayMode(.inline)
//#endif

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
    @AppStorage("fontSize") var fontSize = 50.0
    @AppStorage("showingSearch") var showingSearch = true
    @AppStorage("symbol_arabic") private var arabicSetting = false
    @AppStorage("symbol_bengali") private var bengaliSetting = false // bn
    @AppStorage("symbol_burmese") private var burmeseSetting = false
    @AppStorage("symbol_chinese") private var chineseSetting = false
    @AppStorage("symbol_gujarati") private var gujaratiSetting = false // gu
    @AppStorage("symbol_hebrew") private var hebrewSetting = false
    @AppStorage("symbol_hindi") private var hindiSetting = false
    @AppStorage("symbol_japanese") private var japaneseSetting = false
    @AppStorage("symbol_kannada") private var kannadaSetting = false // kn
    @AppStorage("symbol_khmer") private var khmerSetting = false
    @AppStorage("symbol_korean") private var koreanSetting = false
    @AppStorage("symbol_latin") private var latinSetting = false // el
    @AppStorage("symbol_malayalam") private var malayalamSetting = false // ml
    @AppStorage("symbol_manipuri") private var manipuriSetting = false // mni
    @AppStorage("symbol_oriya") private var oriyaSetting = false // or
    @AppStorage("symbol_russian") private var russianSetting = false // ru
    @AppStorage("symbol_santali") private var santaliSetting = false // sat
    @AppStorage("symbol_telugu") private var teluguSetting = false // te
    @AppStorage("symbol_thai") private var thaiSetting = false
    @AppStorage("symbol_punjabi") private var punjabiSetting = false // pa
    @AppStorage("showingTitle") var showingTitle = true
    @AppStorage("showingCanvas") var showingCanvas = true
    @AppStorage("searchText") var searchText = ""
}

#Preview {
    @Previewable var tabModel = TabModel()
    @Previewable var system = System()
    @Previewable var fontWeight: FontWeights = .regular
    @Previewable var renderMode: RenderModes = .monochrome
    SymbolView(
        renderMode: .constant(renderMode),
        fontWeight: .constant(fontWeight),
        symbols: system.symbols
    )
        .environmentObject(tabModel)
}
