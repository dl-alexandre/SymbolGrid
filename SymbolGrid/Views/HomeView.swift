//
//  ContentView.swift
//  SymbolView
//
//  Created by Dalton Alexandre on 5/24/24.
//

import SwiftUI
import SFSymbolKit
import UniformTypeIdentifiers
import CoreSpotlight

struct HomeView: View {
    var body: some View {
        ZStack {
            SymbolView(renderMode: $selectedSample, fontWeight: $selectedWeight, symbols: symbols)
#if os(iOS)
            if !systemName.isEmpty {
                iconLabel(icon: systemName)
            }
#endif
            if showingWeight {
                weightPicker()
            }
            if showingRender {
                renderingPicker()
            }
        }
        .edgesIgnoringSafeArea(.all)
    }
    @AppStorage("showingRender") var showingRender = false
    @AppStorage("showingWeight") var showingWeight = false
    @AppStorage("showingCanvas") var showingCanvas = false
    @AppStorage("canvasIcon") var canvasIcon = ""
    @AppStorage("fontSize") var fontSize = 50.0
    @AppStorage("systemName") var systemName = ""
    
    @State private var isTapped: Bool = false
    @State private var isLoading: Bool = true
    @State private var needsNewJSON: Bool = false
    @State private var selectedSample = RenderModes.monochrome
    @State private var selectedWeight = FontWeights.medium
    @State private var isCopied = false
    @State private var tapLocation: CGPoint = .zero
    
    var symbols: [String]
    
    @ViewBuilder
    func renderingPicker() -> some View {
        VStack {
            Spacer()
            Spacer()
            Spacer()
            Picker("", selection: $selectedSample) {
                ForEach(RenderModes.allCases, id: \.self) { sample in
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
                    .shadow(color: .white, radius: 1, x: -2, y: -2)
                    .shadow(color: .gray, radius: 1, x: 2, y: 2)
                    .overlay {
                        ScrollView(.horizontal) {
                            Text("\(Image(systemName: "\(icon)")) \(icon)")
                                .font(.headline)
                                .bold()
                                .padding()
                        }
                    }.padding()
            }
            .onTapGesture(count: 1) {
                withAnimation(.spring()) {
                    isCopied.toggle()
                }
#if os(iOS)
                UIPasteboard.general.setValue(icon, forPasteboardType: UTType.plainText.identifier)
#else
                NSPasteboard.general.setString(icon, forType: .string)
#endif
            }
            copyNotification(isCopied: $isCopied, icon: $systemName)
        }.frame(maxHeight: .infinity, alignment: .top)
            .offset(y: fontSize + 20)
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
            .onTapGesture {
                print("Canvas Activated")
            }
        }
    }
}

#Preview {
    @Previewable var tabModel = TabModel()
    @Previewable var system = System()
    @Previewable var fw: FontWeights = .regular
    @Previewable var rm: RenderModes = .monochrome
    HomeView(symbols: System().symbols).environmentObject(tabModel)
}
