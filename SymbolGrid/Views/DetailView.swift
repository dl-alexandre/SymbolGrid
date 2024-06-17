//
//  DetailView.swift
//  SymbolGrid
//
//  Created by Dalton on 6/16/24.
//

import SwiftUI
import SFSymbolKit

struct DetailView: View {
    var icon: Icon
    var animation: Namespace.ID
    @State var color: Color
    @State private var selectedScale = ImageScales.medium
    @State private var selectedWeight = FontWeights.regular
    @State private var isDragging = false
    @State private var offset = CGSize.zero
    @State private var accumulatedOffset = CGSize.zero
    @State var shadow: Color = .clear
    @State var fontSize = 200.0
    @State private var linearValue: Double = log10(200)
    var exponentialValue: Double {
        get {
            pow(10, linearValue)
        }
        set {
            linearValue = log10(newValue)
            fontSize = newValue
        }
    }
    
    var body: some View {
        let dragGesture = DragGesture()
            .onChanged { value in offset = value.translation
                print(offset)
            }
            .onEnded { _ in
                withAnimation {
                    accumulatedOffset = offset
                    offset = accumulatedOffset
                    isDragging = false
                }
            }
        let pressGesture = LongPressGesture()
            .onEnded { value in
                withAnimation {
                    isDragging = true
                }
            }
        
        let combined = pressGesture.sequenced(before: dragGesture)
        
        GeometryReader { geo in
            ZStack {
                Image(systemName: icon.id)
                    .font(.system(size: fontSize, weight: selectedWeight.weight))
                    .imageScale(selectedScale.scale)
                    .foregroundStyle(color.gradient)
                    .scaleEffect(isDragging ? 1.5 : 1)
                    .offset(offset)
                    .offset(y: 100)
                    .gesture(combined)
                    .shadow(color: shadow, radius: 3, x: offset.width, y: offset.height - 10)
                    .frame(maxWidth: .infinity, minHeight: 50, maxHeight: .infinity, alignment: .top)
                    .edgesIgnoringSafeArea(.all)
#if os(iOS)
                    .navigationTransition(.zoom(sourceID: icon.id, in: animation))
#endif
                
                VStack {
                    Spacer()
                    ScrollView {
                        Rectangle().foregroundColor(.clear)
                        VStack {
                            HStack {
                                Text("Scale:")
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
                                Spacer()
                                Text("Weight:")
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
                            }
                            HStack {
                                Text("Size: \(fontSize, specifier: "%.0f")")
                                Slider(value: Binding(
                                    get: { self.linearValue },
                                    set: { newValue in
                                        self.linearValue = newValue
                                        self.fontSize = pow(10, newValue)
                                    }
                                ), in: log10(9)...log10(300))
                            }
                            HStack {
                                ColorPicker("Foreground", selection: $color)
                                ColorPicker("Shadow: ", selection: $shadow)
                            }
                        }.frame(maxWidth: geo.size.width, maxHeight: 100, alignment: .bottom)
                    }
                    .frame(maxWidth: geo.size.width, maxHeight: 100, alignment: .bottom)
//                    .border(.cyan)
                }
                .padding(.horizontal)
            }.onTapGesture(count: 2) {
                offset = CGSize.zero
            }
        }
    }
}

#Preview {
    @Previewable @Namespace var animation
    DetailView(icon: Icon(id: "plus"), animation: animation, color: .red)
}

import SwiftUI

struct SFSConfig: View {
    //    @State var selectedColor = ColorMode.solid
    //    @State var foreground: Color = .black
    //    @State var foreground2: Color = .black
    //    @State var foreground3: Color = .black
    //    @State var foreground4: Color = .black
    @State var fontSize = 200.0
    @State private var selectedScale = ImageScales.small
    @State private var selectedWeight = FontWeights.black
    @State private var isDragging = false
    @State private var offset = CGSize.zero
    @State private var accumulatedOffset = CGSize.zero
    @State var shadow: Color = .green
    
    var body: some View {
        let dragGesture = DragGesture()
            .onChanged { value in offset = value.translation
                print(offset)
            }
            .onEnded { _ in
                withAnimation {
                    accumulatedOffset = offset
                    offset = accumulatedOffset
                    isDragging = false
                }
            }
        let pressGesture = LongPressGesture()
            .onEnded { value in
                withAnimation {
                    isDragging = true
                }
            }
        
        let combined = pressGesture.sequenced(before: dragGesture)
        
        ZStack(alignment: .bottom) {
            Image(systemName: "globe")
                .font(.system(size: fontSize, weight: selectedWeight.weight))
                .imageScale(selectedScale.scale)
            //                .foregroundColor(foreground)
            //                .foregroundColor(LinearGradient(colors: [foreground, foreground2, foreground3], startPoint: .top, endPoint: .topLeading))
            
            
                .scaleEffect(isDragging ? 1.5 : 1)
                .offset(offset)
                .offset(y: -300)
                .gesture(combined)
                .shadow(color: shadow, radius: 3, x: 10, y: 10)
                .shadow(color: .red, radius: 3, x: -10, y: -10)
            
            VStack(alignment: .center) {
                Spacer()
                Spacer()
                Spacer()
                Group {
                    //                    HStack {
                    //                        Picker("", selection: $selectedColor) {
                    //                            ForEach(ColorMode.allCases, id: \.self) { color in
                    //                                Capsule()
                    //                                    .overlay {
                    //                                        Text(color.name)
                    //                                            .font(.headline)
                    //                                    }
                    //                                    .tag(color)
                    //                            }
                    //                        }.pickerStyle(.menu)
                    //                        if selectedColor == ColorMode.solid {
                    //                            ColorPicker("", selection: $foreground)
                    //                        } else if selectedColor == ColorMode.linearGradient {
                    //                            ColorPicker("", selection: $foreground)
                    //                            ColorPicker("", selection: $foreground2)
                    //                            ColorPicker("", selection: $foreground3)
                    //                        } else if selectedColor == ColorMode.radialGradient {
                    //                            ColorPicker("", selection: $foreground)
                    //                            ColorPicker("", selection: $foreground2)
                    //                            ColorPicker("", selection: $foreground3)
                    //                        } else if selectedColor == ColorMode.meshGradient {
                    //                            ColorPicker("", selection: $foreground)
                    //                            ColorPicker("", selection: $foreground2)
                    //                            ColorPicker("", selection: $foreground3)
                    //                            ColorPicker("", selection: $foreground4)
                    //                        }
                    //                    }
                    HStack {
                        Text("Font Scale:")
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
                        Spacer()
                        Text("Weight:")
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
                    }
                    HStack {
                        Text("Size: \(fontSize, specifier: "%.0f")")
                        Slider(value: $fontSize, in: 9...500)
                    }
                    HStack {
                        ColorPicker("Shadow: ", selection: $shadow)
                    }
                }
                .padding(.horizontal)
            }
        }.onTapGesture(count: 2) {
            offset = CGSize.zero
        }
    }
}
//
//enum ColorMode {
//    case solid(Color)
//    case linearGradient(Color, Color)
//    case radialGradient(Color, Color)
//    case meshGradient(Color, Color, Color, Color)
//
//    var name: String {
//        switch self {
//        case .solid: return "Solid"
//        case .linearGradient: return "LinearGradient"
//        case .radialGradient: return "RadialGradient"
//        case .meshGradient: return "MeshGradient"
//        }
//    }
//
//    //    var pattern1: Color {
//    //        switch self {
//    //        case .solid(let foregroundColor):
//    //            return foregroundColor
//    //        case .linearGradient(foregroundColor, foregroundColor):
//    //            return foregroundColor
//    //        case .radialGradient(foregroundColor, foregroundColor):
//    //            return foregroundColor
//    //        case .meshGradient(foregroundColor, foregroundColor, foregroundColor, foregroundColor):
//    //            return foregroundColor
//    //        }
//    //    }
//
//    var pattern: some View {
//        switch self {
//        case .solid(let foregroundColor):
//            return AnyView(foregroundColor)
//        case .linearGradient(let foregroundColor, let foregroundColor2):
//            return AnyView(LinearGradient(
//                gradient: Gradient(colors: [foregroundColor, foregroundColor2]),
//                startPoint: .topLeading,
//                endPoint: .bottomTrailing
//            ))
//        case .radialGradient(let foregroundColor, let foregroundColor2):
//            return AnyView(RadialGradient(
//                gradient: Gradient(colors: [foregroundColor, foregroundColor2]),
//                center: .center,
//                startRadius: 10,
//                endRadius: 100
//            ))
//        case .meshGradient(let foregroundColor, let foregroundColor2, let foregroundColor3, let foregroundColor4):
//            return AnyView(MeshGradient(
//                width: 2,
//                height: 2,
//                points: [
//                    [0, 0],
//                    [1, 0],
//                    [0, 1],
//                    [1, 1]
//                ],
//                colors: [foregroundColor, foregroundColor2, foregroundColor3, foregroundColor4]
//            ))
//        }
//    }
//}

enum ImageScales: Int, CaseIterable {
    case small, medium, large
    
    var name: String {
        switch self {
        case .small: return "Small"
        case .medium: return "Medium"
        case .large: return "Large"
        }
    }
    var scale: Image.Scale {
        switch self {
        case .small: return .small
        case .medium: return .medium
        case .large: return .large
        }
    }
}
