//
//  SheetView.swift
//  SymbolGrid
//
//  Created by Dalton on 6/15/24.
//

import SwiftUI

struct SheetView: View {
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
        symbols: [String]
    )
    {
        self.symbols = symbols
    }

    @Namespace var animation
    @State private var selected: Icon?
    
    var body: some View {
        let icons: [Icon] = searchResults.map { symbolName in
            Icon(id: symbolName)
        }
        ScrollView {
            LazyVGrid(columns: [.init(.adaptive(minimum: 30, maximum: 50))]) {
                ForEach(icons) { icon in
                    Button {
                        selected = icon
                    } label: {
                        Image(systemName: icon.id)
                    }
                    //                .foregroundStyle(icon.color.gradient)
                    .font(.system(size: 20))
                    .matchedTransitionSource(id: icon.id, in: animation)
                }
            }
        }
        .sheet(item: $selected) { icon in
            DestinationView(icon: icon, animation: animation, color: .blue)
                .presentationDetents([.medium])
        }
    }
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


struct DestinationView: View {
    var icon: Icon
    var animation: Namespace.ID
    var color: Color
    var body: some View {
        Image(systemName: icon.id)
            .font(.system(size: 300))
            .foregroundStyle(color.gradient)
        #if os(iOS)
            .navigationTransition(.zoom(sourceID: icon.id, in: animation))
        #endif
    }
}

struct Icon: Identifiable {
    var id: String
}


#Preview {
    @Previewable var system = System()
    SheetView(symbols: system.symbols)
}
