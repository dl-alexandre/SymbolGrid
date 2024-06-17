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
    @State var shadow: Color = .clear.opacity(0.5)
    @State var fontSize = 200.0
    @State private var linearValue: Double = log10(200)
    @Environment(\.presentationMode) var presentationMode
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
#if os(macOS)
                                Button {
                                    presentationMode.wrappedValue.dismiss()
                                } label: {
                                    Image(systemName: "xmark").foregroundColor(.red)
                                }
#endif
                            }
                        }.frame(maxWidth: geo.size.width, maxHeight: 100, alignment: .bottom)
                    }
                    .frame(maxWidth: geo.size.width, maxHeight: 100, alignment: .bottom)
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


