//
//  File.swift
//  SymbolView
//
//  Created by Dalton Alexandre on 5/24/24.
//

import SwiftUI
import UniformTypeIdentifiers


struct SymbolGrid: View {
    @Environment(\.layoutDirection) private var layoutDirection
    @AppStorage("Arabic") private var arabicSetting = true
    @AppStorage("Hebrew") private var hebrewSetting = true
    @AppStorage("Hindi") private var hindiSetting = true
    @AppStorage("Japanese") private var japaneseSetting = true
    @AppStorage("Korean") private var koreanSetting = true
    @AppStorage("Thai") private var thaiSetting = true
    @AppStorage("Chinese") private var chineseSetting = true
    @Binding public var icon: String
    @Binding public var searchText: String
    @Binding public var isSearching: Bool
    @Binding private var isChoosingRender: Bool
    @Binding public var isTapped: Bool
    @Binding public var isLoading: Bool
    @Binding public var renderMode: RenderSamples
    init(
        icon: Binding<String>,
        searchText: Binding<String>,
        isSearching: Binding<Bool>,
        isChoosingRender: Binding<Bool>,
        isTapped: Binding<Bool>,
        isLoading: Binding<Bool>,
        renderMode: Binding<RenderSamples>,
        symbols: [String]
    )
    {
        self._icon = icon
        self._searchText = searchText
        self._isSearching = isSearching
        self._isChoosingRender = isChoosingRender
        self._isTapped = isTapped
        self._isLoading = isLoading
        self._renderMode = renderMode
        self.symbols = symbols
    }
    
    @AppStorage("gridsize") var GridSize = 50.0
    private var columns: [GridItem] {
        [GridItem(.adaptive(minimum: 1.5 * GridSize))]
    }
    
    private var spacing: CGFloat {
        GridSize * 0.1
    }
    
    var symbols: [String]
    
    var searchResults: [String] {
        return symbols.filter { key in
            #if os(macOS)
            if !arabicSetting && key.hasSuffix(".ar") { return false }
            if !hebrewSetting && key.hasSuffix(".he") { return false }
            if !hindiSetting && key.hasSuffix(".hi") { return false }
            if !japaneseSetting && key.hasSuffix(".ja") { return false }
            if !koreanSetting && key.hasSuffix(".ko") { return false }
            if !thaiSetting && key.hasSuffix(".th") { return false }
            if !chineseSetting && key.hasSuffix(".zh") { return false }
            
                // Apply search text filter if searchText is not empty
            if !searchText.isEmpty { return key.contains(searchText.lowercased()) }
            return true // Include the key if none of the above conditions are met and searchText is empty
            #else
            if arabicSetting && key.hasSuffix(".ar") { return false }
            if hebrewSetting && key.hasSuffix(".he") { return false }
            if hindiSetting && key.hasSuffix(".hi") { return false }
            if japaneseSetting && key.hasSuffix(".ja") { return false }
            if koreanSetting && key.hasSuffix(".ko") { return false }
            if thaiSetting && key.hasSuffix(".th") { return false }
            if chineseSetting && key.hasSuffix(".zh") { return false }
            
            if !searchText.isEmpty { return key.contains(searchText.lowercased()) }
            return true
            #endif
        }
    }
    
    var body: some View {
        GeometryReader { geometryProxy in
            ScrollViewReader { scrollViewProxy in
                ScrollView([.vertical]) {
                    LazyVGrid(columns: columns, spacing: spacing) {
                        ForEach(searchResults, id: \.hash) { systemName in
                            Image(systemName: systemName)
                                .symbolRenderingMode(renderMode.mode)
                                .font(.system(size: (GridSize)))
                                .animation(.linear, value: 0.5)
                                .foregroundColor(self.icon == systemName ? Color.accentColor : Color.primary)
                                .contentShape(Circle())
                                .onTapGesture {
                                    withAnimation {
                                        if self.icon.isEmpty {
                                            self.icon = systemName
                                        } else if self.icon == systemName {
                                            self.icon = ""
                                        } else {
                                            self.icon = systemName
                                        }
                                    }
                                }
                                .contextMenu {
                                    SymbolContextMenu(icon: icon, gridSize: GridSize)
                                    Section("Color Mode") {
                                        Button {
                                            isChoosingRender.toggle()
                                        } label: {
                                            Label("Render", systemImage: "paintbrush")
                                        }
                                    }
                                    Section("Search") {
                                        Button {
                                            isSearching.toggle()
                                            print("trying to search")
                                        } label: {
                                            Label("Search", systemImage: "magnifyingglass")
                                        }
                                    }
                                } preview: {
                                    Text("\(systemName)").font(.title)
                                }
                        }
                        .frame(maxWidth: 500)
                        .defaultScrollAnchor(.center)
                    }
                    .focusable()
                    .focusEffectDisabled()
                }
                .coordinateSpace(name: "scroll")
                .offset(x: 0, y: searchText.isEmpty ? 0: 150)
                .edgesIgnoringSafeArea(.top)
#if os(iOS)
                .navigationBarTitleDisplayMode(.inline)
#endif
                .toolbar {
                    ToolbarItem(placement: .automatic) {
                        Text("\(icon)")
                            .padding()
                            .onTapGesture(count: 1) {
#if os(macOS)
                                NSPasteboard.general.setString(icon, forType: .string)
#endif
                            }
                    }
                }
            }
        }
    }
}

enum RenderSamples: Int, CaseIterable {
    case monochrome
    case multicolor
    case hierarchical
    case palette
    var name: String {
        switch self {
            case .monochrome:
                return "Monochrome"
            case .multicolor:
                return "Multicolor"
            case .hierarchical:
                return "Hierarchical"
            case .palette:
            return "Palette" }
    }
    var mode: SymbolRenderingMode {
        switch self {
            case .monochrome:
                return .monochrome
            case .multicolor:
                return .multicolor
            case .hierarchical:
                return .hierarchical
            case .palette:
                return .palette
        }
    }
}
