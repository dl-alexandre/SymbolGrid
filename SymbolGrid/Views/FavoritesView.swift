//
//  Favorites.swift
//  SymbolView
//
//  Created by Dalton Alexandre on 5/30/24.
//

import SwiftUI
import Design
import SFSymbolKit

struct FavoritesView: View {
    var body: some View {
        let icons: [Icon] = searchResults.map { symbolName in
            Icon(id: symbolName)
        }
        
        ZStack {
            if myFavorites.isEmpty {
                ContentUnavailableView {
                    Label("Favorites", systemImage: "star.slash")
                } description: {
                    Text("Find your favorite symbols here")
                    Button {
                        if tabModel.activeTab == .home {
                            tabModel.activeTab = .favorites
                        } else {
                            tabModel.activeTab = .home
                        }
                    } label: {
                        Label("Show", systemImage: "line.horizontal.star.fill.line.horizontal")
                    }
                }
            } else {
                ScrollView {
                    LazyVGrid(columns: columns, spacing: spacing) {
                        ForEach(icons) { icon in
                            favorite(icon: icon, font: dynamicFont, isCopied: $isCopied, selected: $selected, tabModel: tabModel)
                                .onChange(of: dynamicFont) {
                                    print(dynamicFont)
                                }
                                .environmentObject(tabModel)
                        }
                        
                    }
                    
                    .offset(x: 0, y: showingTitle ? fontSize * 3: 20)
                    Rectangle().frame(height: fontSize * 3).foregroundColor(.clear)
#if os(iOS)
                        .navigationBarTitleDisplayMode(.inline)
#endif
                    
                        .toolbar {
                            ToolbarItem(placement: .principal) {
                                copyNotification(isCopied: $isCopied, icon: $systemName)
                            }
                            ToolbarItem(placement: .secondaryAction) {
                                if tabModel.activeTab == .favorites {
                                    Menu {
                                        
                                        Menu {
                                            ForEach(SF.allCases, id: \.self) { font in
                                                Button {
                                                    selectedFont = font
                                                } label: {
                                                    Text(font.name)
                                                }
                                            }
                                        } label: {
                                            Text("Font")
                                        }
                                        Menu {
                                            ForEach(Style.allCases, id: \.self) { style in
                                                Button {
                                                    selectedStyle = style
                                                } label: {
                                                    Text(style.name)
                                                }
                                            }
                                        } label: {
                                            Text("Style")
                                        }
                                        Menu {
                                            ForEach(FontWeights.allCases, id: \.self) { weight in
                                                Button {
                                                    selectedWeight = weight
                                                    
                                                } label: {
                                                    Text(weight.name)
                                                }
                                            }
                                        } label: {
                                            Text("Weight")
                                        }
                                        Toggle("Italic", isOn: $italic)
                                            .disabled(fontWithoutItalics.contains(baseFontName))
                                    } label: {
                                        Label("\(FontName)", systemImage: "abc")
                                            .padding()
                                    }
                                }
                            }
                        }
                    
                }.padding()
                
                
                    .sheet(item: $selected) { icon in
                        DetailView(icon: icon, animation: animation, color: icon.color)
                            .presentationDetents([.medium])
                    }
                
            }
//            if showingSearch {
//                searchBar(text: $searchText, focus: $searchField, showingSearch: $showingSearch)
//            }
            if showingTitle {
                customTitleBar("Favorites")
            }
        }
        .onAppear {
            for item in icons {
                addIconToIndex(item.id, "com.alexandrefamilyfarm.symbols")
            }
            
            showingTitle = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
                withAnimation(.easeInOut(duration: 2)) {
                    showingTitle = false
                }
            }
        }
        .edgesIgnoringSafeArea(.all)
    }
    
    @ViewBuilder
    func customTitleBar(_ label: String) -> some View {
        VStack {
            Capsule()
                .fill(.ultraThinMaterial)
                .frame(maxWidth: .infinity, maxHeight: 40, alignment: .trailing)
                .shadow(color: .white, radius: 1, x: -2, y: -2)
                .shadow(color: .gray, radius: 1, x: 2, y: 2)
                .overlay {
                    Text(label)
                        .font(.largeTitle)
                        .foregroundColor(.gray)
                        .bold()
                        .padding()
                    
                }
                .defaultScrollAnchor(.trailing)
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding()
                .onTapGesture(count: 1) {
                    withAnimation(.spring()) {
                        showingTitle = true
                    }
                }
        }
        .frame(maxHeight: .infinity, alignment: .top)
        .offset(y: fontSize + 20)
    }
    
    @EnvironmentObject private var tabModel: TabModel
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
    @AppStorage("favorites") private var favorites: String = "[]"
    @AppStorage("showingSearch") var showingSearch = false
    @AppStorage("showingTitle") var showingTitle = true
    @AppStorage("searchText") var searchText = ""
    @AppStorage("fontSize") var fontSize = 50.0
    @AppStorage("systemName") var systemName = ""
    @FocusState private var searchField: Field?
    @Namespace var animation
    @Binding public var renderMode: RenderModes
    @Binding public var fontWeight: FontWeights
    @State private var selected: Icon?
    @State private var selectedFontWeight = FontWeights.medium
    @State private var selectedFont: SF = .pro
    @State private var selectedStyle: Style = .text
    @State private var selectedWeight: FontWeights = .regular
    @State private var italic = false
    @State private var isCopied = false
    
    
    var myFavorites: [String] {
        get { Array(jsonString: favorites) ?? [] }
        set { favorites = newValue.jsonString() ?? "[]" }
    }
    
    var searchResults: [String] {
        return myFavorites.filter { key in
            
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
    
    let fontWithoutItalics = [
        "SFCompactRounded",
        "SFCompactDisplay"
    ]
    
    var baseFontName: String {
        "SF\(selectedFont)\(selectedStyle)"
    }
    
    var FontName: String {
        let FontName = "\(baseFontName)-\(selectedWeight)"
        return italic ? "\(FontName)Italic" : FontName
    }
    
    var dynamicFont: Font {
        return .custom(FontName, size: fontSize/2)
    }
    
    private var columns: [GridItem] {
        [GridItem(.flexible())]
    }
    
    private var spacing: CGFloat {
        fontSize * 0.1
    }
}



