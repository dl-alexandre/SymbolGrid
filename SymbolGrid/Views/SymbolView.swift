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
    )
    {
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
    
    @Binding public var renderMode: RenderModes
    @Binding public var fontWeight: FontWeights
    
    var body: some View {
        let icons: [Icon] = searchResults.map { symbolName in
            Icon(id: symbolName)
        }
        GeometryReader { geo in
            ScrollView {
                LazyVGrid(columns: columns, spacing: spacing) {
                    ForEach(icons) { icon in
                        Symbol(systemName: icon, fontSize: fontSize, fontWeight: fontWeight, renderMode: renderMode, selected: $selected).environmentObject(tabModel)
                            .font(.system(size: 20))
                            .matchedTransitionSource(id: icon.id, in: animation)
                    }
                }.offset(x: 0, y: searchText.isEmpty ? 0: (fontSize * 3))
            }
            .sheet(item: $selected) { icon in
                DetailView(icon: icon, animation: animation, color: .blue)
#if os(macOS)
                    .frame(minWidth: geo.size.width * 0.25, minHeight: geo.size.height * 0.50)
#endif
                    .presentationDetents([.medium])
            }
        }
#if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
#endif
//#if os(macOS)
//        .toolbar {
//            ToolbarItem(placement: .automatic) {
//                Text("\(icon)")
//                    .padding()
//                    .onTapGesture(count: 1) {
//                        NSPasteboard.general.setString(icon, forType: .string)
//                        print(icon)
//                    }
//            }
//        }
//#endif
        
    }
    @AppStorage("fontSize") var fontSize = 50.0
    @AppStorage("symbol_arabic") private var arabicSetting = false
    @AppStorage("symbol_bengali") private var bengaliSetting = false //bn
    @AppStorage("symbol_burmese") private var burmeseSetting = false
    @AppStorage("symbol_chinese") private var chineseSetting = false
    @AppStorage("symbol_gujarati") private var gujaratiSetting = false //gu
    @AppStorage("symbol_hebrew") private var hebrewSetting = false
    @AppStorage("symbol_hindi") private var hindiSetting = false
    @AppStorage("symbol_japanese") private var japaneseSetting = false
    @AppStorage("symbol_kannada") private var kannadaSetting = false //kn
    @AppStorage("symbol_khmer") private var khmerSetting = false
    @AppStorage("symbol_korean") private var koreanSetting = false
    @AppStorage("symbol_latin") private var latinSetting = false //el
    @AppStorage("symbol_malayalam") private var malayalamSetting = false //ml
    @AppStorage("symbol_manipuri") private var manipuriSetting = false //mni
    @AppStorage("symbol_oriya") private var oriyaSetting = false //or
    @AppStorage("symbol_russian") private var russianSetting = false //ru
    @AppStorage("symbol_santali") private var santaliSetting = false //sat
    @AppStorage("symbol_telugu") private var teluguSetting = false //te
    @AppStorage("symbol_thai") private var thaiSetting = false
    @AppStorage("symbol_punjabi") private var punjabiSetting = false //pa
    @AppStorage("searchText") var searchText = ""
}


#Preview {
    @Previewable var tabModel = TabModel()
    @Previewable var system = System()
    @Previewable var fw: FontWeights = .regular
    @Previewable var rm: RenderModes = .monochrome
    SymbolView(renderMode: .constant(rm), fontWeight: .constant(fw), symbols: system.symbols).environmentObject(tabModel)
}
