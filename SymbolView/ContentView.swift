    //
    //  ContentView.swift
    //  SymbolView
    //
    //  Created by Dalton Alexandre on 5/24/24.
    //

import SwiftUI
import UniformTypeIdentifiers
//#warning("make symbol Preview")
struct ContentView: View {
    enum Field: Hashable {
        case symbolGrid
        case searchBar
    }
    @AppStorage("showingSearch") var showingSearch = false
    @AppStorage("showingRender") var showingRender = false
    @AppStorage("showingWeight") var showingWeight = false
    @AppStorage("showingCanvas") var showingCanvas = false
    @AppStorage("canvasIcon") var canvasIcon = ""
    @AppStorage("fontSize") var fontSize = 50.0
    @AppStorage("searchText") var searchText = ""
    @FocusState private var focus: Field?
    @State private var icon = ""
    @State private var isTapped: Bool = false
    @State private var isLoading: Bool = true
    @State private var needsNewJSON: Bool = false
    @State private var selectedSample = SymbolRenderings.monochrome
    @State private var selectedWeight = FontWeights.medium
    @State private var isCopied = false
    @State private var tapLocation: CGPoint = .zero
    var symbols: [String]
    var body: some View {
        ZStack {
            VStack {
                Spacer(minLength: 10)
                SymbolGrid(icon: $icon, renderMode: $selectedSample, fontWeight: $selectedWeight, symbols: symbols)
            }
#if os(iOS)
            if !icon.isEmpty {
                iconLabel(icon: icon)
            }
#endif
            if showingSearch {
                searchBar(text: $searchText)
            }
            if showingWeight {
                weightPicker()
            }
            if showingRender {
                renderingPicker()
            }
//            if showingCanvas {
//                symbolCanvas(icon: icon)
//            }
        }
    }
    
    @ViewBuilder
    func renderingPicker() -> some View {
        VStack {
            Spacer()
            Spacer()
            Spacer()
            Picker("", selection: $selectedSample) {
                ForEach(SymbolRenderings.allCases, id: \.self) { sample in
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
                    showingRender = false
                }
            }
        }
    }
    
    @ViewBuilder
    func weightPicker() -> some View {
        VStack {
            Spacer()
            Spacer()
            Picker("", selection: $selectedWeight) {
                ForEach(FontWeights.allCases, id: \.self) { weight in
                    Text(weight.name)
                        .font(.title)
                        .fontWeight(weight.weight)
                        .tag(weight)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: 120, alignment: .trailing)
            .foregroundColor(.primary)
            .background(.quaternary)
            .cornerRadius(9)
            #if os(iOS)
            .pickerStyle(WheelPickerStyle())
            #else
            .pickerStyle(SegmentedPickerStyle())
            #endif
            Spacer()
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
                withAnimation {
                    showingWeight = false
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
                    .fill(.ultraThinMaterial)
                    .frame(maxWidth: .infinity, maxHeight: 40, alignment: .trailing)
                    .overlay {
                        ScrollView(.horizontal) {
                            HStack {
                                Spacer()
                                Spacer()
                                Text("\(icon)")
                                    .font(.headline)
                                    .bold()
//                                    .foregroundColor(.black)
                                    .padding()
                            }
                       }.defaultScrollAnchor(.trailing)
                            .frame(maxWidth: .infinity, alignment: .trailing)
                    }.padding()
            }.onTapGesture(count: 1) {
                withAnimation(.spring()) {
                    isCopied.toggle()
                }
#if os(iOS)
                UIPasteboard.general.setValue(icon, forPasteboardType: UTType.plainText.identifier)
#else
                    /// Mac Copypasta
                print(icon)
#endif
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
//                .border(.ultraThinMaterial, width: 10)
                .cornerRadius(20)
                .overlay {
                    TextField("Search Symbols", text: text)
                        .focused($focus, equals: .searchBar)
                        .foregroundColor(.primary)
                        .padding()
                }.padding()
        }
//        .onAppear {
//            
//            DispatchQueue.main.asyncAfter(deadline: .now() + 15) {
//                withAnimation {
//                    showingSearch = false
//                }
//            }
//        }
    }
    
    @ViewBuilder
    func symbolCanvas(icon: String) -> some View {
        GeometryReader { geo in
            VStack {
                Rectangle()
                    .fill(.ultraThickMaterial)
                    .frame(maxWidth: geo.size.width / 4, maxHeight: geo.size.height / 4, alignment: .topLeading)
                    .border(.ultraThinMaterial, width: 10)
                    .cornerRadius(20)
                    .overlay {
                        Image(systemName: canvasIcon)
                            .font(.system(size: fontSize * 3))
                            .foregroundColor(.primary)
                            .padding()
                    }.padding()
            }
//            .onAppear {
//                DispatchQueue.main.asyncAfter(deadline: .now() + 15) {
//                    withAnimation {
//                        showingCanvas = false
//                    }
//                }
//            }
            .onTapGesture {
                print("Canvas Activated")
            }
        }
    }
}

    //#Preview {
    //    ContentView()
    //}
