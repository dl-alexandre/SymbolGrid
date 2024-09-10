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
    var tabModel = TabModel()
    @FocusState private var isSearchFieldFocused: Bool

    var body: some View {
        Section {
            HStack {
                Button {
                    UIPasteboard.general .setValue(icon.id.description,
                                                   forPasteboardType: UTType.plainText .identifier)
                } label: {
                    Label("", systemImage: "doc.on.doc")
                }
                .buttonStyle(BorderlessButtonStyle())
                Button {
                    detailIcon = icon
                } label: {
                    Label("\(icon.id)", systemImage: "\(icon.id)")
                }
                if favoritesBinding.wrappedValue.isEmpty {
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
                Button {
                    if favoritesBinding.wrappedValue.contains(icon.id) {
                        removeFavorite(symbols: icon.id)
                    } else {
                        addFavorite(symbols: icon.id)
                    }
                } label: {
                    if favoritesBinding.wrappedValue.contains(icon.id) {
                        Label("", systemImage: "star.fill")
                    } else {
                        Label("", systemImage: "star")
                    }
                }
                //.font(.subheadline)
                .buttonStyle(BorderlessButtonStyle())
            }.buttonStyle(BorderedProminentButtonStyle())
            Stepper(value: $fontSize, in: 9...200, step: 5) {
                Text("Size")
            }.padding(.horizontal)
                .onChange(of: fontSize) { oldValue, newValue in
                    fontSize = min(max(newValue, 9), 200)
                }
        }.font(.title)
        weightPicker(selectedWeight: $selectedWeight)
        renderingPicker(selectedSample: $selectedSample)
        Button {
            searchText = icon.id
            showingSearch = true
            dismiss()
            $isSearchFieldFocused.wrappedValue = true
        } label: {
            Label("Search", systemImage: "magnifyingglass")
        }

    }
}

#Preview {
    MenuSheet(icon: Icon(id: "square", color: Color.random()), detailIcon: .constant(Icon(id: "square", color: Color.random())), selectedWeight: .constant(FontWeights.regular), selectedSample: .constant(RenderModes.monochrome))
}
