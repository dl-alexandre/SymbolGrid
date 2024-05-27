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
    @AppStorage("symbol_arabic") private var arabicSetting = false
    @AppStorage("symbol_hebrew") private var hebrewSetting = false
    @AppStorage("symbol_hindi") private var hindiSetting = false
    @AppStorage("symbol_japanese") private var japaneseSetting = false
    @AppStorage("symbol_korean") private var koreanSetting = false
    @AppStorage("symbol_thai") private var thaiSetting = false
    @AppStorage("symbol_chinese") private var chineseSetting = false
    @Binding public var icon: String
    @Binding public var searchText: String
    @Binding public var renderMode: SymbolRenderings
    @Binding public var fontWeight: FontWeights
    init(
        icon: Binding<String>,
        searchText: Binding<String>,
        renderMode: Binding<SymbolRenderings>,
        fontWeight: Binding<FontWeights>,
        symbols: [String]
    )
    {
        self._icon = icon
        self._searchText = searchText
        self._renderMode = renderMode
        self._fontWeight = fontWeight
        self.symbols = symbols
    }
    
    @AppStorage("fontSize") var fontSize = 50.0
    private var columns: [GridItem] {
        [GridItem(.adaptive(minimum: 1.5 * fontSize))]
    }
    
    private var spacing: CGFloat {
        fontSize * 0.1
    }
    
    var symbols: [String]
    
    var searchResults: [String] {
        return symbols.filter { key in
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
                                .font(.system(size: (fontSize), weight: fontWeight.weight))
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
                                    SymbolContextMenu(icon: icon, fontSize:  fontSize)
                                } preview: {
                                    Group {
                                        Image(systemName: systemName).font(.system(size: (fontSize * 4), weight: fontWeight.weight))
                                        Text("\(systemName)").font(.title)
                                    }
                                        .padding()
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
