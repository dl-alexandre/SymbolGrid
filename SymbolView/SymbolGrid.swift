    //
    //  File.swift
    //  SymbolView
    //
    //  Created by Dalton Alexandre on 5/24/24.
    //

import SwiftUI
import SFSymbolKit
import UniformTypeIdentifiers


struct SymbolGrid: View {
    @Environment(\.layoutDirection) private var layoutDirection
    @AppStorage("symbol_arabic") private var arabicSetting = false
    @AppStorage("symbol_burmese") private var burmeseSetting = false
    @AppStorage("symbol_hebrew") private var hebrewSetting = false
    @AppStorage("symbol_hindi") private var hindiSetting = false
    @AppStorage("symbol_japanese") private var japaneseSetting = false
    @AppStorage("symbol_khmer") private var khmerSetting = false
    @AppStorage("symbol_korean") private var koreanSetting = false
    @AppStorage("symbol_thai") private var thaiSetting = false
    @AppStorage("symbol_chinese") private var chineseSetting = false
    @AppStorage("searchText") var searchText = ""
    @AppStorage("fontSize") var fontSize = 50.0
    @Binding public var icon: String
    @Binding public var renderMode: RenderModes
    @Binding public var fontWeight: FontWeights
    
    init(
        icon: Binding<String>,
        renderMode: Binding<RenderModes>,
        fontWeight: Binding<FontWeights>,
        symbols: [String]
    )
    {
        self._icon = icon
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
    
    var symbols: [String]
    
    var searchResults: [String] {
        return symbols.filter { key in
            if !arabicSetting && key.hasSuffix(".ar") { return false }
            if !burmeseSetting && key.hasSuffix(".my") { return false }
            if !hebrewSetting && key.hasSuffix(".he") { return false }
            if !hindiSetting && key.hasSuffix(".hi") { return false }
            if !japaneseSetting && key.hasSuffix(".ja") { return false }
            if !khmerSetting && key.hasSuffix(".km") { return false }
            if !koreanSetting && key.hasSuffix(".ko") { return false }
            if !thaiSetting && key.hasSuffix(".th") { return false }
            if !chineseSetting && key.hasSuffix(".zh") { return false }
            
                // Apply search text filter if searchText is not empty
            if !searchText.isEmpty { return key.contains(searchText.lowercased()) }
            return true // Include the key if none of the above conditions are met and searchText is empty
        }
    }
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: spacing) {
                ForEach(searchResults, id: \.hash) { systemName in
                    Symbol(systemName: systemName, icon: $icon, fontSize: fontSize, fontWeight: fontWeight, renderMode: renderMode)
                    
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
                        print(icon)
#endif
                    }
            }
        }
    }
}


struct Symbol: View {
    let systemName: String
    @Binding var icon: String
    let fontSize: CGFloat
    let fontWeight: FontWeights
    var renderMode: RenderModes
    
    var body: some View {
        Image(systemName: systemName)
            .symbolRenderingMode(renderMode.mode)
            .font(.system(size: fontSize, weight: fontWeight.weight))
            .animation(.linear, value: 0.5)
            .foregroundColor(icon == systemName ? Color.secondary : Color.primary)
            .onTapGesture {
                withAnimation {
                    if icon.isEmpty {
                        icon = systemName
                    } else if icon == systemName {
                        icon = ""
                    } else {
                        icon = systemName
                    }
                }
            }
        
            .onDrag {
                let provider = NSItemProvider(object: (Image(systemName: systemName).asNSImage() ?? Image(systemName: "plus").asNSImage()!) as NSImage)
                return provider
            }
            .previewLayout(.sizeThatFits)
            .contextMenu {
                SymbolContextMenu(fontSize: fontSize, icon: icon)
            }
            .previewLayout(.sizeThatFits)
    }
}

extension View {
    func asNSImage() -> NSImage? {
        let hostingView = NSHostingView(rootView: self)
        hostingView.setFrameSize(hostingView.fittingSize)
        guard let bitmapRep = hostingView.bitmapImageRepForCachingDisplay(in: hostingView.bounds) else { return nil }
        hostingView.cacheDisplay(in: hostingView.bounds, to: bitmapRep)
        let image = NSImage(size: hostingView.bounds.size)
        image.addRepresentation(bitmapRep)
        return image
    }
}
