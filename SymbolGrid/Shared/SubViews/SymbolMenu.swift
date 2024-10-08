//
//  WeightPickerView.swift
//  SymbolGrid
//
//  Created by Dalton Alexandre on 9/14/24.
//

import SwiftUI
import SwiftData
import SFSymbolKit

struct SymbolMenu: View {
    @Environment(\.verticalSizeClass) var verticalSizeClass
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.modelContext) private var moc
    @Query var favorites: [Favorite]
    @Binding var fontSize: Double
    @Binding var selectedWeight: Weight
    @Binding var selectedMode: SymbolRenderingModes
    @Binding var showingSymbolMenu: Bool
    @Binding var showingSearch: Bool
    @Binding var showingFavorites: Bool
    @State private var vmo = ViewModel()

    var body: some View {
        GeometryReader { geo in
            RoundedRectangle(cornerRadius: 9)
                .fill(.ultraThinMaterial)
                .frame(
                    maxWidth: .infinity,
                    maxHeight: geo.size.height / 4,
                    alignment: .trailing
                )
                .shadow(
                    color: colorScheme == .dark ? .gray : .white.opacity(0.2),
                    radius: 1,
                    x: -2,
                    y: -2
                )
                .shadow(
                    color: colorScheme == .dark ? .gray : .white.opacity(0.2),
                    radius: 1,
                    x: 2,
                    y: 2
                )
                .overlay {
                    VStack {
                        if verticalSizeClass == .regular {
                            HStack {
                                Button {
                                    showingSearch = true
                                    showingSymbolMenu = false
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
                                if !favorites.isEmpty {
                                    Button {
                                        showingFavorites.toggle()
                                    } label: {
                                        Image(systemName: "sparkles.rectangle.stack")
                                            .symbolRenderingMode(.palette)
                                            .foregroundStyle(.yellow, colorScheme == .dark ? .white : .black)
                                    }
                                }
                                Button {
                                    withAnimation {
                                        showingSymbolMenu = false
                                    }
                                } label: {
                                    Image(systemName: "xmark")
                                        .foregroundStyle(.red)
                                }
                            }
                            HStack {
                                VStack {
                                    Text("Symbol Rendering").font(.caption2)
                                    SymbolRenderingModes.picker(mode: $selectedMode)
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
                                VStack {
                                    Text("Font Weight").font(.caption2)
                                    Weight.picker(weight: $selectedWeight)
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
                            }.padding(.top)
                        } else {
                            HStack {
                                Button {
                                    showingSearch = true
                                    showingSymbolMenu = false
                                } label: {
                                    Label("", systemImage: "magnifyingglass")
                                }
                                Stepper(value: $fontSize, in: 9...200, step: 5) {
                                    Text("Symbol Size").font(.caption)
                                }
                                .onChange(of: fontSize) { _, newValue in
                                    fontSize = min(max(newValue, 9), 200)
                                }
                                Weight.picker(weight: $selectedWeight)
                                    .frame(maxWidth: .infinity, maxHeight: 80, alignment: .trailing)
                                    .foregroundColor(.primary)
                                    .background(.quaternary)
                                    .cornerRadius(9)
#if os(iOS)
                                    .pickerStyle(WheelPickerStyle())
#else
                                    .pickerStyle(SegmentedPickerStyle())
#endif
                                SymbolRenderingModes.picker(mode: $selectedMode)
                                    .frame(maxWidth: .infinity, maxHeight: 80, alignment: .trailing)
                                    .foregroundColor(.primary)
                                    .background(.quaternary)
                                    .cornerRadius(9)
#if os(iOS)
                                    .pickerStyle(WheelPickerStyle())
#else
                                    .pickerStyle(SegmentedPickerStyle())
#endif
                                if !favorites.isEmpty {
                                    Button {
                                        showingFavorites.toggle()
                                    } label: {
                                        Image(systemName: "sparkles.rectangle.stack")
                                            .symbolRenderingMode(.palette)
                                            .foregroundStyle(.yellow, colorScheme == .dark ? .white : .black)
                                    }
                                }
                                Button {
                                    withAnimation {
                                        showingSymbolMenu = false
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
            showingSymbolMenu = true
//            DispatchQueue.main.asyncAfter(deadline: .now() + 15) {
//                withAnimation(.easeInOut(duration: 2)) {
//                    showSymbolMenu = false
//                }
//            }
        }
    }
}

#Preview {
    SymbolMenu(
        fontSize: .constant(50.0),
        selectedWeight: .constant(.regular),
        selectedMode: .constant(.monochrome),
        showingSymbolMenu: .constant(false),
        showingSearch: .constant(false),
        showingFavorites: .constant(false)
    )
}
