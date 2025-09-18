//
//  DetailView.swift
//  SymbolGrid
//
//  Created by Dalton on 6/16/24.
//

import SwiftUI
import UniformTypeIdentifiers
import SFSymbolKit
import Design

struct DetailView: View {
    @Environment(\.presentationMode) private var presentationMode
    @Environment(\.colorScheme) var colorScheme
    var icon: Symbol
    @Binding var fontSize: Double
    @Binding var showingDetail: Bool

    @State private var vmo = ViewModel()
    @State private var showShadow: Bool = false
    @State private var showSize: Bool = false
    @State private var showScale: Bool = false
    @State private var showWeight: Bool = false
    @State private var showForeground: Bool = false
    @State private var color: Color = .random()
    @State private var showAlert = false
    @State private var selectedScale = Scale.medium
    @State private var selectedWeight = Weight.regular
    @State private var accumulatedOffset = CGSize.zero
    @State private var offset = CGSize.zero
    @State private var isDragging = false
    @State private var shadow: Color = .gray.opacity(0.5)
    @State private var glyphSize = 200.0
    @State private var linearValue: Double = log10(200)

#if os(iOS)
    @State var location: CGPoint = .zero
#else
    @State var location: CGPoint = .zero
#endif

    var body: some View {
        GeometryReader { geo in
            ZStack {
                let image = Image(systemName: icon.name)
                    .font(.system(size: glyphSize, weight: selectedWeight.weight))
                    .imageScale(selectedScale.scale)
                    .foregroundStyle(showForeground ?
                        color.gradient : colorScheme == .dark ?
                        Color.gray.gradient : Color.black.gradient
                    )
                    .shadow(
                        color: showShadow ? shadow : .clear,
                        radius: 3,
                        x: offset.width,
                        y: offset.height - 10
                    )
                    .frame(maxWidth: .infinity, minHeight: 50, maxHeight: .infinity, alignment: .top)
#if os(iOS)
                image
                    .position(location)
#else
                image
#endif
                VStack {
                    let code = "Image(systemName: \"\(icon.name)\")"
                    let scaleConfig = configureScale(
                        showScale: showScale,
                        selectedScale: selectedScale.scale
                    )
                    let fontConfig = configureFont(
                        showSize: showSize,
                        showWeight: showWeight,
                        fontSize: glyphSize,
                        selectedWeight: selectedWeight
                    )
                    let colorConfig = configureColor(
                        showForeground: showForeground,
                        color: color
                    )
                    let shadowConfig = configureShadow(
                        showShadow: showShadow,
                        shadow: shadow,
                        offset: offset
                    )
                    ScrollView {
                        Spacer()
                        ScrollView(.horizontal) {
                            CodeText(
                                code: code + scaleConfig + fontConfig + colorConfig + shadowConfig
                            )
                        }
                        .scrollIndicators(.hidden)
                        .rotationEffect(Angle(degrees: 180.0))
                    }.rotationEffect(Angle(degrees: 180.0))
                    ScrollView {
                        ScrollView(.horizontal) {
                            Text("\(icon.name)")
                                .font(.title)
                                .multilineTextAlignment(.leading)
                                .fixedSize(horizontal: false, vertical: true)
                        }.defaultScrollAnchor(.leading).scrollIndicators(.hidden)
                        VStack {
                            HStack {
                                if showScale {
                                    Button {
                                        showScale.toggle()
                                    } label: {
                                        Text("Scale:").font(.caption)
                                    }.buttonStyle(BorderedProminentButtonStyle())
                                    Picker("", selection: $selectedScale) {
                                        ForEach(Scale.allCases, id: \.self) { scale in
                                            Capsule()
                                                .overlay {
                                                    Text(scale.name)
                                                        .font(.headline)
                                                }
                                                .tag(scale)
                                        }
                                    }.pickerStyle(.menu)
                                } else {
                                    Button {
                                        showScale.toggle()
                                    } label: {
                                        Text("Scale")
                                    }.padding(4)
                                }
                                if showWeight {
                                    Spacer()
                                    Button {
                                        showWeight.toggle()
                                    } label: {
                                        Text("Weight:").font(.caption)
                                    }.buttonStyle(BorderedProminentButtonStyle())
                                    Picker("", selection: $selectedWeight) {
                                        ForEach(Weight.allCases, id: \.self) { weight in
                                            Capsule()
                                                .overlay {
                                                    Text(weight.name)
                                                        .font(.headline)
                                                }
                                                .tag(weight)
                                        }
                                    }.pickerStyle(.menu)
                                } else {
                                    Button {
                                        showWeight.toggle()
                                        showSize = true
                                    } label: {
                                        Text("Weight")
                                    }.padding(4)
                                }
                            }
                            HStack {
                                if showSize {
                                    Button {
                                        showSize.toggle()
                                        showWeight = false
                                    } label: {
                                        Text("Size:")
                                    }.buttonStyle(BorderedProminentButtonStyle())
                                    Text(" \(glyphSize, specifier: "%.0f")")
                                    Slider(value: Binding(
                                        get: { self.linearValue },
                                        set: { newValue in
                                            self.linearValue = newValue
                                            self.glyphSize = pow(10, newValue)
                                        }
                                    ), in: log10(9)...log10(300))
                                } else {
                                    Button {
                                        showSize.toggle()
                                    } label: {
                                        Text("Size")
                                    }.padding(4)
                                }
                            }
                            HStack {
                                if showForeground {
                                    ColorPicker(selection: $color) {
                                        Button {
                                            showForeground.toggle()
                                        } label: {
                                            Text("Color: ")
                                        }.buttonStyle(BorderedProminentButtonStyle())
                                    }
                                } else {
                                    Button {
                                        showForeground = true
                                    } label: {
                                        Text("Color")
                                    }.padding(4)
                                }
                                if showShadow {
                                    ColorPicker(selection: $shadow) {
                                        Button {
                                            showShadow.toggle()
                                        } label: {
                                            Text("Shadow: ")
                                        }.buttonStyle(BorderedProminentButtonStyle())
                                    }
                                } else {
                                    Button {
                                        showShadow = true
                                    } label: {
                                        Text("Shadow")
                                    }.padding(4)
                                }
                            }
                            HStack {
                                Button {
                                    let text = code + scaleConfig + fontConfig + colorConfig + shadowConfig
                                    withAnimation(.spring()) {
                                        vmo.copy()
                                    }
#if os(macOS)
                                    NSPasteboard.general.setString(text, forType: .string)
#else
                                    UIPasteboard.general .setValue(
                                        text.description,
                                        forPasteboardType: UTType.plainText .identifier
                                    )
#endif
                                } label: {
                                    Image(systemName: "doc.on.doc")
                                        .padding()
                                }
                                Button {
                                    withAnimation {
                                        showingDetail = false
                                    }
                                } label: {
                                    Image(systemName: "xmark")
                                        .padding()
                                        .foregroundStyle(.red)
                                }
                            }
                            .font(.system(size: fontSize))
                            .padding(4)
                            copyNotification(isCopied: $vmo.isCopied, icon: $vmo.systemName)
                        }
                    }
                    .frame(maxHeight: geo.size.height/3, alignment: .bottomLeading)
                }
                .padding(.horizontal)
            }
            .onTapGesture(count: 2) {
#if os(iOS)
                location = CGPoint(x: geo.size.width / 2, y: geo.size.height / 2)
#else
                location = CGPoint(x: geo.size.width / 2, y: geo.size.height / 2)
#endif
            }
            .onAppear {
                location = CGPoint(x: geo.size.width / 2, y: geo.size.height / 2)
            }
        }
        .background(
            RoundedRectangle(cornerRadius: 16)
        )
    }
}

#Preview {
    var mathCategory = SymbolCategory(
        icon: CategoryTokens.math.icon,
        key: CategoryTokens.math.key,
        label: CategoryTokens.math.label
    )

#if os(iOS)
    DetailView(
        icon: Symbol(
            name: "plus",
            categories: [mathCategory]
        ),
        fontSize: .constant(50.0),
        showingDetail: .constant(true)
    )
#else
    DetailView(
        icon: Symbol(
            name: "plus",
            categories: [mathCategory]
        ),
        fontSize: .constant(50.0),
        showingDetail: .constant(true)
    )
#endif
}
