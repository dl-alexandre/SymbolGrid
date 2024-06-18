//
//  SplashView.swift
//  SymbolGrid
//
//  Created by Dalton on 6/17/24.
//

import SwiftUI
import SFSymbolKit

struct PreSplashView2: View {
    var body: some View {
        let limitedIcons: [Icon] = Array(searchResults.prefix(200)).map { symbolName in
            Icon(id: symbolName)
        }
        
        GeometryReader { geo in
            ZStack {
                ProgressView()
                ScrollView {
                    LazyVGrid(columns: columns, spacing: spacing) {
                        ForEach(limitedIcons) { icon in
                            Image(systemName: icon.id)
                                .symbolRenderingMode(renderMode.mode)
                                .font(.system(size: fontSize, weight: fontWeight.weight))
                                .symbolEffect(.breathe.byLayer.pulse)
                                .foregroundStyle(Color.random())
                                .onAppear {
                                    isAnimating = true
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 3.4) {
                                        withAnimation(.easeInOut(duration: 2)) {
                                            isAnimating = false
                                        }
                                    }
                                }
                                .animation(.default, value: isAnimating)
                        }
                    }.offset(x: 0, y: searchText.isEmpty ? 0: (fontSize * 3))
                }
            }
        }
    }
    
    @EnvironmentObject private var tabModel: TabModel
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
    
//    init(
//        renderMode: Binding<RenderModes>,
//        fontWeight: Binding<FontWeights>,
//        symbols: [String],
//        isAnimating: Binding<Bool>
//    )
//    {
//        self._renderMode = renderMode
//        self._fontWeight = fontWeight
//        self.symbols = symbols
//        self.isAnimating = isAnimating
//    }
    
    @Binding public var renderMode: RenderModes
    @Binding public var fontWeight: FontWeights
    @Binding var isAnimating: Bool
    @State private var selected: Icon?
    
    private var columns: [GridItem] {
        [GridItem(.adaptive(minimum: 1.5 * fontSize))]
    }
    
    private var spacing: CGFloat {
        fontSize * 0.1
    }
}

#Preview {
    @Previewable var tabModel = TabModel()
    @Previewable var system = System()
    @Previewable var fw: FontWeights = .regular
    @Previewable var rm: RenderModes = .monochrome
    @Previewable var se: SymbolEffects = .bounce
    PreSplashView2(symbols: system.symbols, renderMode: .constant(rm), fontWeight: .constant(fw), isAnimating: .constant(true)).environmentObject(tabModel)
}

extension Color {
    static func random() -> Color {
        let red = Double.random(in: 0...1)
        let green = Double.random(in: 0...1)
        let blue = Double.random(in: 0...1)
        return Color(red: red, green: green, blue: blue)
    }
}


struct SplashView: View {
    @Binding var isAnimating: Bool
    var body: some View {
        GifImageView("SymbolGridGif")
            .offset(y: 100)
            .scaledToFill()
            .onAppear {
                isAnimating = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 13.4) {
                    withAnimation {
                        isAnimating = false
                    }
                }
            }
            .animation(.default, value: isAnimating)
    }
}

#Preview {
    SplashView(isAnimating: .constant(true))
}

import WebKit
import SFSymbolKit

#if os(iOS)
struct GifImageView: UIViewRepresentable {
    private let name: String
    init(_ name: String) {
        self.name = name
    }
    func makeUIView(context: Context) -> WKWebView {
        let webview = WKWebView()
        let url = Bundle.main.url(forResource: name, withExtension: "gif")!
        let data = try! Data(contentsOf: url)
        webview.load(data, mimeType: "image/gif", characterEncodingName: "UTF-8", baseURL: url.deletingLastPathComponent())
        return webview
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        uiView.reload()
    }
}
#else
struct GifImageView: NSViewRepresentable {
    private let name: String
    
    init(_ name: String) {
        self.name = name
    }
    
    func makeNSView(context: Context) -> WKWebView {
        let webview = WKWebView()
        let url = Bundle.main.url(forResource: name, withExtension: "gif")!
        let data = try! Data(contentsOf: url)
        webview.load(data, mimeType: "image/gif", characterEncodingName: "UTF-8", baseURL: url.deletingLastPathComponent())
        return webview
    }
    
    func updateNSView(_ nsView: WKWebView, context: Context) {
        nsView.reload()
    }
}
#endif
