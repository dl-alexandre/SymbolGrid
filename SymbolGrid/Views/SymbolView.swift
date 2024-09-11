//
//  SheetView.swift
//  SymbolGrid
//
//  Created by Dalton on 6/15/24.
//

import SwiftUI
import SFSymbolKit

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

    @Binding public var renderMode: RenderModes
    @Binding public var fontWeight: FontWeights
    @FocusState public var isSearchFieldFocused: Bool

    @State private var position = ScrollPosition(edge: .top)

    @State private var showSheet = false

    var body: some View {
        let icons: [Icon] = searchResults.map { symbolName in
            Icon(id: symbolName)
        }

        ZStack {
                ScrollView {
                    LazyVGrid(columns: columns, spacing: spacing) {
                        ForEach(icons) { icon in
                            Button {
                                selected  = icon
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
                            } label: {
                                symbol(
                                    icon: icon,
                                    selected: $selected,
                                    tabModel: tabModel,
                                    renderMode: $renderMode,
                                    fontWeight: $fontWeight
                                )
                                .padding(8)
                                .matchedTransitionSource(id: icon.id, in: animation)
                                .hoverEffect(.highlight)
                            }.buttonStyle(BorderlessButtonStyle())
                        }
                    }.offset(x: 0, y: searchText.isEmpty ? 0: (fontSize * 3))
                }
                .scrollPosition($position)
#if os(iOS)
                .sheet(isPresented: $showSheet) {
                    if let selectedIcon = selected {
                        MenuSheet(
                            icon: selectedIcon,
                            detailIcon: $detailIcon,
                            selectedWeight: $fontWeight,
                            selectedSample: $renderMode
                        )
                            .presentationBackgroundInteraction(.enabled)
                            .presentationDetents([.large])
                            .sheet(item: $detailIcon) { icon in
                                DetailView(icon: icon, animation: animation, color: icon.color)
                                    .presentationDetents([.large])
                            }
                    }

                }
#endif

            if showingTitle {
                if let selectedIcon = selected {
                    customTitleBar("\(selectedIcon.id)")
                        .padding()
                        .onTapGesture(count: 1) {
#if os(macOS)
                            NSPasteboard.general.setString(selectedIcon.id, forType: .string)
                            print(selectedIcon.id)
#endif
                        }
                }

            }
        }
        .onAppear {
            showingTitle = true
            //            DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
            //                withAnimation(.easeInOut(duration: 2)) {
            //                    showingTitle = false
            //                }
            //            }
        }
#if os(iOS)
        .onTapGesture(count: 2) {
            showingSearch.toggle()
        }
        .navigationBarTitleDisplayMode(.inline)
#endif
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
