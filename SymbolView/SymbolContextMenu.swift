//
//  File.swift
//  SymbolView
//
//  Created by Dalton Alexandre on 5/24/24.
//

import SwiftUI
import UniformTypeIdentifiers

struct SymbolContextMenu: View {
    @AppStorage("showingSearch") var showingSearch = true
    @AppStorage("showingRender") var showingRender = true
    @AppStorage("showingWeight") var showingWeight = true
    @AppStorage("showingCanvas") var showingCanvas = false
    @AppStorage("canvasIcon") var canvasIcon = ""
    @AppStorage("fontSize") var fontSize = 50.0
    var icon: String
    
    var body: some View {
#if os(iOS)
            Button {
                UIPasteboard.general .setValue(icon.description,
                                               forPasteboardType: UTType.plainText .identifier)
            } label: {
                Label("Copy", systemImage: "doc.on.doc")
            }

            Section("Size") {
                Stepper(value: $fontSize, in: 9...200, step: 10) { EmptyView() }
                
            }
            
#endif
                Button {
                    showingWeight.toggle()
                } label: {
                    Label("Weight", systemImage: "arrowtriangle.left.and.line.vertical.and.arrowtriangle.right.fill")
                }
                Button {
                    showingRender.toggle()
                } label: {
                    Label("Render", systemImage: "paintbrush")
                }
                Button {
                    showingSearch.toggle()
                } label: {
                    Label("Search", systemImage: "magnifyingglass")
                }
    }
}

#Preview {
    SymbolContextMenu(icon: "doc.on.doc")
}

