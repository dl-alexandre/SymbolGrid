//
//  ContentView.swift
//  SymbolView
//
//  Created by Dalton Alexandre on 5/24/24.
//

import SwiftUI
import UniformTypeIdentifiers

struct ContentView: View {
    enum Field: Hashable {
        case symbolGrid
        case searchBar
    }
    @AppStorage("showingSearch") var showingSearch = true
    @AppStorage("searchText") var searchText = ""
    @FocusState private var focus: Field?
    @State private var icon = ""
    @State private var isSearching: Bool = false
    @State private var isChoosingRender: Bool = false
    @State private var isTapped: Bool = false
    @State private var isLoading: Bool = true
    @State private var needsNewJSON: Bool = false
    @State private var selectedSample = RenderSamples.monochrome
    @State private var isCopied = false
    @State private var tapLocation: CGPoint = .zero
    var symbols: [String]
    var body: some View {
        ZStack {
            VStack {
                Spacer(minLength: 10)
                SymbolGrid(icon: $icon, searchText: $searchText, isSearching: $isSearching, isChoosingRender: $isChoosingRender, isTapped: $isTapped, isLoading: $isLoading, renderMode: $selectedSample, symbols: symbols)
            }
#if os(iOS)
            if !icon.isEmpty {
                iconLabel(icon: icon)
            }
#endif
            
            if !showingSearch {
                searchBar(text: $searchText)
                    .focused($focus, equals: .searchBar)
            }
            if isChoosingRender {
                renderPicker()
            }
        }
    }
    
    @ViewBuilder
    func renderPicker() -> some View {
        GeometryReader { geo in
            VStack {
                Spacer()
                Spacer()
                Spacer()
                Picker("", selection: $selectedSample) {
                    ForEach(RenderSamples.allCases, id: \.self) { sample in
                        Capsule()
                            .overlay {
                                Text(sample.name)
                                    .font(.headline)
                            }
                            .tag(sample)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: 40, alignment: .trailing)
                .background(.secondary)
                .cornerRadius(9)
                .pickerStyle(SegmentedPickerStyle())
                Spacer()
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
                    withAnimation {
                        isChoosingRender = false
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    func iconLabel(icon: String) -> some View {
        VStack {
            HStack {
                Spacer()
                Capsule()
                    .fill(.primary)
                    .frame(maxWidth: .infinity, maxHeight: 40, alignment: .trailing)
                    .overlay {
                        ScrollView(.horizontal) {
                            HStack {
                                Spacer()
                                Spacer()
                                Text("\(icon)")
                                    .font(.headline)
                                    .bold()
                                    .foregroundColor(.accentColor)
                                    .padding()
                            }
                        }.defaultScrollAnchor(.trailing)
                            .frame(maxWidth: .infinity, alignment: .trailing)
                    }.padding()
            }.onTapGesture(count: 1) {
                withAnimation(.spring()) {
                    isCopied.toggle()
                }
                UIPasteboard.general.setValue(icon, forPasteboardType: UTType.plainText.identifier)
                print(icon)
            }
            if isCopied {
                Text("Copied")
                    .font(.body)
                    .bold()
                    .foregroundColor(.green)
                    .transition(.move(edge: .bottom))
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            withAnimation(.easeOut(duration: 0.2)) { 
                                isCopied = false
                            }
                        }
                    }
            }
            Spacer()
        }
    }
    
    @ViewBuilder
    func searchBar(text: Binding<String>) -> some View {
        VStack {
            Spacer()
            Capsule()
                .fill(.ultraThickMaterial)
                .frame(maxWidth: .infinity, maxHeight: 40, alignment: .bottomLeading)
                .border(.ultraThinMaterial, width: 10)
                .cornerRadius(20)
                .overlay {
                    TextField("Search Symbols", text: text)
                        .foregroundColor(.primary)
                        .padding()
                }.padding()
        }
        .onAppear {
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 15) {
                withAnimation {
                    isSearching = false
                }
            }
        }
    }
}

//#Preview {
//    ContentView()
//}
