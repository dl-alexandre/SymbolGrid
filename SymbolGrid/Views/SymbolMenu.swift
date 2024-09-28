//
//  WeightPickerView.swift
//  SymbolGrid
//
//  Created by Dalton Alexandre on 9/14/24.
//

import SwiftUI
import SFSymbolKit

struct SymbolMenu: View {
    @AppStorage("fontSize") var fontSize = 50.0
    @AppStorage("showingSearch") var showingSearch = true
    @AppStorage("searchText") var searchText = ""
    @AppStorage("showWeightPicker") var showWeightPicker = false
    @Binding var selectedWeight: FontWeights
    @Binding var selectedSample: RenderModes
    @Environment(\.verticalSizeClass) var verticalSizeClass

    @FocusState private var isSearchFieldFocused: Bool

    var body: some View {
        GeometryReader { geo in
            RoundedRectangle(cornerRadius: 9)
                .fill(.ultraThinMaterial)
                .frame(maxWidth: .infinity, maxHeight: geo.size.height / 4, alignment: .trailing)
                .shadow(color: .white.opacity(0.2), radius: 1, x: -2, y: -2)
                .shadow(color: .gray, radius: 1, x: 2, y: 2)
                .overlay {
                    VStack {
                        if verticalSizeClass == .regular {
                            HStack {
                                Button {
                                    showingSearch = true
                                    $isSearchFieldFocused.wrappedValue = true
                                    showWeightPicker = false
                                } label: {
                                    Label("", systemImage: "magnifyingglass")
                                }
                                Stepper(value: $fontSize, in: 9...200, step: 5) {
                                    Text("Symbol Size").font(.caption)
                                }
                                .frame(width: geo.size.width / 2 - geo.size.width / 20)
                                .onChange(of: fontSize) { _, newValue in
                                    fontSize = min(max(newValue, 9), 200)
                                }
                                Button {
                                    withAnimation {
                                        showWeightPicker = false
                                    }
                                } label: {
                                    Image(systemName: "xmark")
                                        .foregroundStyle(.red)
                                }
                            }
                            HStack {
                                VStack {
                                    Text("Symbol Rendering").font(.caption2)
                                    renderPicker2(selectedSample: $selectedSample)
                                }
                                VStack {
                                    Text("Font Weight").font(.caption2)
                                    weightPicker(selectedWeight: $selectedWeight)
                                }
                            }.padding(.top)
                        } else {
                            HStack {
                                Button {
                                    showingSearch = true
                                    $isSearchFieldFocused.wrappedValue = true
                                    showWeightPicker = false
                                } label: {
                                    Label("", systemImage: "magnifyingglass")
                                }
                                Stepper(value: $fontSize, in: 9...200, step: 5) {
                                    Text("Symbol Size").font(.caption)
                                }
                                .onChange(of: fontSize) { _, newValue in
                                    fontSize = min(max(newValue, 9), 200)
                                }
                                weightPicker(selectedWeight: $selectedWeight)
                                renderPicker2(selectedSample: $selectedSample)
                                Button {
                                    withAnimation {
                                        showWeightPicker = false
                                    }
                                } label: {
                                    Image(systemName: "xmark")
                                }
                                .foregroundStyle(.red)
                            }
                        }

                    }
                    .padding(geo.size.width / 30)
                }
                .padding(geo.size.width / 60)
        }
        .onAppear {
            showWeightPicker = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 15) {
                withAnimation(.easeInOut(duration: 2)) {
                    showWeightPicker = false
                }
            }
        }
    }
}

#Preview {
    SymbolMenu(selectedWeight: .constant(.regular), selectedSample: .constant(.monochrome))
}

@ViewBuilder
func renderPicker2(selectedSample: Binding<RenderModes>) -> some View {
    VStack {
        Picker("", selection: selectedSample) {
            ForEach(RenderModes.allCases, id: \.self) { sample in
                let image = Image(
                    systemName: "textformat.abc.dottedunderline")
                    .symbolRenderingMode(sample.mode)
                Text("\(image) \(sample.name)")
                    .font(.headline)
                    .tag(sample)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: 80, alignment: .trailing)
        .foregroundColor(.primary)
        .background(.quaternary)
        .cornerRadius(9)
#if os(iOS)
        .pickerStyle(WheelPickerStyle())
#else
        .pickerStyle(SegmentedPickerStyle())
#endif
    }
}
