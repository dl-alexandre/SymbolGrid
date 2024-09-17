//
//  MenuSheet.swift
//  SymbolGrid
//
//  Created by Dalton Alexandre on 9/10/24.
//

import SwiftUI
import SFSymbolKit
import UniformTypeIdentifiers

struct MenuSheet: View {
    @Environment(\.dismiss) var dismiss
    @AppStorage("favorites") var favorites: String = "[]"
    @AppStorage("showingSearch") var showingSearch = true
    @AppStorage("showingRender") var showingRender = true
    @AppStorage("showingWeight") var showingWeight = true
    @AppStorage("fontSize") var fontSize = 50.0
    @AppStorage("searchText") var searchText = ""

    var favoritesBinding: Binding<[String]> {
        Binding(
            get: { Array(jsonString: favorites) ?? [] },
            set: { favorites = $0.jsonString() ?? "[]" }
        )
    }

    var icon: Icon
    @Binding var detailIcon: Icon?
    @Binding var selectedWeight: FontWeights
    @Binding var selectedSample: RenderModes
    @Binding var showInspector: Bool
    var tabModel = TabModel()
    @FocusState private var isSearchFieldFocused: Bool
#if os(macOS)
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
#endif
    @State var showDetail = false
    var body: some View {

        VStack {
            HStack {
                Button {
#if os(iOS)
                    UIPasteboard.general .setValue(icon.id.description,
                                                   forPasteboardType: UTType.plainText .identifier)
#else
                    let pasteboard = NSPasteboard.general
                    pasteboard.declareTypes([.string], owner: nil)
                    pasteboard.setString(icon.id.description, forType: .string)
#endif
                } label: {
                    Label("", systemImage: "doc.on.doc")
                }
                .buttonStyle(BorderlessButtonStyle())
                Button {
                    detailIcon = icon
                    showDetail.toggle()
                } label: {
                    Label("\(icon.id)", systemImage: "\(icon.id)")
                }
                Button {
                    if favoritesBinding.wrappedValue.contains(icon.id) {
                        removeFavorite(symbols: icon.id)
                    } else {
                        addFavorite(symbols: icon.id)
                    }
                } label: {
                    if favoritesBinding.wrappedValue.contains(icon.id) {
                        Label("", systemImage: "star.fill")
                            .foregroundStyle(.yellow)
                    } else {
                        Label("", systemImage: "star")
                    }
                }
                .buttonStyle(BorderlessButtonStyle())
                Button {
                    showInspector.toggle()
                } label: {
                    Label("", systemImage: "sparkles")
                }
                .buttonStyle(BorderlessButtonStyle())
            }.buttonStyle(BorderedProminentButtonStyle())
        }
#if os(macOS)
        .inspector(isPresented: $showDetail) {
            DetailView(icon: icon)
                .inspectorColumnWidth(min: 300, ideal: 500, max: 1000)
        }
#endif
    }
}

#Preview {
    MenuSheet(
        icon: Icon(id: "square", color: Color.random()),
        detailIcon: .constant(Icon(id: "square", color: Color.random())),
        selectedWeight: .constant(FontWeights.regular),
        selectedSample: .constant(RenderModes.monochrome),
        showInspector: .constant(false)
    )
}
