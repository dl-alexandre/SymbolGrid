//
//  DetailView.swift
//  SymbolGrid
//
//  Created by Dalton on 6/16/24.
//

import SwiftUI
import SFSymbolKit
import SwiftFormat

func configureShadow(showShadow: Bool, icon: Icon, shadow: Color, offset: CGSize) -> String {
    var shadowConfig = ""

    let hex = shadow.description.trimmingCharacters(in: CharacterSet(charactersIn: "#"))
    let scanner = Scanner(string: hex)
    var rgbValue: UInt64 = 0
    if scanner.scanHexInt64(&rgbValue) {

        if showShadow {
            shadowConfig = """

        .shadow(
            color: Color(#colorLiteral(
                red: \(String(format: "%.1f", Double((rgbValue & 0xFF0000) >> 16))) / 255.0,
                green: \(String(format: "%.1f", Double((rgbValue & 0x00FF00) >> 8))) / 255.0,
                blue: \(String(format: "%.1f", Double(rgbValue & 0x0000FF))) / 255.0,
                alpha: \(String(format: "%.1f", Double((rgbValue & 0xFF000000) >> 24))) / 255.0)),
            radius: 3,
            x: \(String(format: "%.0f", offset.width)),
            y: \(String(format: "%.0f", offset.height)) - 10)
        """
        }
    }

    return shadowConfig
}

func configureColor(showForeground: Bool, icon: Icon) -> String {
    var colorConfig = ""

    let hex = icon.color.description.trimmingCharacters(in: CharacterSet(charactersIn: "#"))
    let scanner = Scanner(string: hex)
    var rgbValue: UInt64 = 0
    if scanner.scanHexInt64(&rgbValue) {

        if showForeground {
            colorConfig = """

        .foregroundStyle(Color(#colorLiteral(
                                    red: \(String(format: "%.1f", Double((rgbValue & 0xFF0000) >> 16))) / 255.0,
                                    green: \(String(format: "%.1f", Double((rgbValue & 0x00FF00) >> 8))) / 255.0,
                                    blue: \(String(format: "%.1f", Double(rgbValue & 0x0000FF))) / 255.0,
                                    alpha: \(String(format: "%.1f", Double((rgbValue & 0xFF000000) >> 24))) / 255.0)))
        """
        }
    }

    return colorConfig
}

func configureFont(showSize: Bool, showWeight: Bool, fontSize: CGFloat, selectedWeight: String) -> String {
    var fontConfig = ""

    if showSize && showWeight {
        fontConfig = """

        .font(.system(
            size: \(String(format: "%.0f", fontSize)),
            weight: .\(selectedWeight)))
        """
    } else if showWeight {
        fontConfig = """

        .font(.system(
            weight: .\(selectedWeight)))
        """
    } else if showSize {
        fontConfig = """

        .font(.system(
            size: \(String(format: "%.0f", fontSize)))
        """
    }

    return fontConfig
}

func configureScale(showScale: Bool, selectedScale: Image.Scale) -> String {
    var scaleConfig = ""

    if showScale {
        scaleConfig = """

        .imageScale(.\(selectedScale))
        """
    }
    return scaleConfig
}

struct DetailView: View {
    var body: some View {
        let dragGesture = DragGesture()
            .onChanged { value in
                self.location = value.location
                self.offset = value.translation
            }
            .onEnded { _ in
                withAnimation {
                    isDragging = false
                }
            }
        let pressGesture = LongPressGesture()
            .onEnded { _ in
                withAnimation {
                    isDragging = true
                }
            }
        let combined = pressGesture.sequenced(before: dragGesture)
        GeometryReader { geo in
            ZStack {
                Image(systemName: icon.id)
                    .textSelection(.enabled)
                    .font(.system(size: fontSize, weight: selectedWeight.weight))
                    .imageScale(selectedScale.scale)
                    .foregroundStyle(color.gradient)
                    .scaleEffect(isDragging ? 1.5 : 1)
                    .position(location)
                    .gesture(combined)
                    .shadow(color: shadow, radius: 3, x: offset.width, y: offset.height - 10)
                    .frame(maxWidth: .infinity, minHeight: 50, maxHeight: .infinity, alignment: .top)
#if os(iOS)
                    .navigationTransition(.zoom(sourceID: icon.id, in: animation))
#endif
                VStack {
                    let code = "Image(systemName: \"\(icon.id)\")"
                    let scaleConfig = configureScale(
                        showScale: showScale,
                        selectedScale: selectedScale.scale
                    )
                    let fontConfig = configureFont(
                        showSize: showSize,
                        showWeight: showWeight,
                        fontSize: fontSize,
                        selectedWeight: selectedWeight.name
                    )
                    let colorConfig = configureColor(
                        showForeground: showForeground,
                        icon: icon
                    )
                    let shadowConfig = configureShadow(
                        showShadow: showShadow,
                        icon: icon,
                        shadow: shadow,
                        offset: offset
                    )
                    ScrollView {
                        Spacer()
                        ScrollView(.horizontal) {
                            CodeText(
                                code: formatSwiftCode(
                                    code + scaleConfig + fontConfig + colorConfig + shadowConfig
                                )!
                            )
                        }
                        .scrollIndicators(.hidden)
                        .rotationEffect(Angle(degrees: 180.0))
                    }.rotationEffect(Angle(degrees: 180.0))
                    ScrollView {
                        ScrollView(.horizontal) {
                            Text("\(icon.id)")
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
                                        ForEach(ImageScales.allCases, id: \.self) { scale in
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
                                        ForEach(FontWeights.allCases, id: \.self) { weight in
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
                                    } label: {
                                        Text("Weight")
                                    }.padding(4)
                                }
                            }
                            HStack {
                                if showSize {
                                    Button {
                                        showSize.toggle()
                                    } label: {
                                        Text("Size:")
                                    }.buttonStyle(BorderedProminentButtonStyle())
                                    Text(" \(fontSize, specifier: "%.0f")")
                                    Slider(value: Binding(
                                        get: { self.linearValue },
                                        set: { newValue in
                                            self.linearValue = newValue
                                            self.fontSize = pow(10, newValue)
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
                            Button {
                                print(formatSwiftCode(code + scaleConfig + fontConfig + colorConfig + shadowConfig)!)
                            } label: {
                                Image(systemName: "doc.on.doc").bold()
                            }.padding(4)
                        }
                    }
                    .frame(/*maxWidth: geo.size.width,*/ maxHeight: geo.size.height/3, alignment: .bottomLeading)
                }
                .padding(.horizontal)
            }.onTapGesture(count: 2) {
#if os(iOS)
                location = CGPoint(x: UIScreen.main.bounds.midX, y: 150)
#else
                location = CGPoint(x: NSScreen.main?.frame.size.width ?? 0, y: 150)
#endif
            }
        }
    }

    @Environment(\.presentationMode) private var presentationMode
    var icon: Icon
#if os(iOS)
    var animation: Namespace.ID
#endif
    @State var showShadow: Bool = false
    @State var showSize: Bool = false
    @State var showScale: Bool = false
    @State var showWeight: Bool = false
    @State var showForeground: Bool = false
    @State var color: Color = .random()
    @State var showAlert = false
    @State private var selectedScale = ImageScales.medium
    @State private var selectedWeight = FontWeights.regular
    @State private var accumulatedOffset = CGSize.zero
    @State private var offset = CGSize.zero
    @State private var isDragging = false
    @State private var shadow: Color = .gray.opacity(0.5)
    @State private var fontSize = 200.0
    @State private var linearValue: Double = log10(200)

    func formatSwiftCode(_ code: String) -> String? {
        let formatter = SwiftFormatter(configuration: Configuration())
        var formattedCode = ""
        do {
            try formatter.format(source: code, assumingFileURL: nil, selection: .infinite, to: &formattedCode)
            return formattedCode
        } catch {
            print("Failed to format code: \(error)")
            return nil
        }
    }

    var exponentialValue: Double {
        get {
            pow(10, linearValue)
        }
        set {
            linearValue = log10(newValue)
            fontSize = newValue
        }
    }

#if os(iOS)
    @State var location: CGPoint = CGPoint(x: UIScreen.main.bounds.midX, y: 150)
#else
    @State var location: CGPoint = CGPoint(x: NSScreen.main?.frame.size.width ?? 0, y: -150)
#endif
}

#Preview {
    @Previewable @Namespace var animation
#if os(iOS)
    DetailView(icon: Icon(id: "square.and.arrow.up.on.square.fill", color: .random(), uiColor: .black), animation: animation)
#else
    DetailView(icon: Icon(id: "plus", color: .random(), uiColor: .black))
#endif
}

extension Color {
    func description() -> String {
#if os(iOS)
        let components = UIColor(self).cgColor.components ?? [0, 0, 0, 0]
#else
        let components = NSColor(self).cgColor.components ?? [0, 0, 0, 0]
#endif
        let red = components[0]
        let green = components[1]
        let blue = components[2]
        let alpha = components[3]

        return String(format: "Color(red: %.2f, green: %.2f, blue: %.2f, opacity: %.2f)", red, green, blue, alpha)
    }
}
