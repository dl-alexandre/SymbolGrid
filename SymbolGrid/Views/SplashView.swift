//
//  SplashView.swift
//  SymbolGrid
//
//  Created by Dalton on 6/17/24.
//

import SwiftUI

struct SplashView: View {
    @Binding var isAnimating: Bool
    var body: some View {
        GifImageView("SymbolGridGif")
            .offset(y: 100)
            .scaledToFill()
            .onAppear {
                isAnimating = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 3.4) {
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
