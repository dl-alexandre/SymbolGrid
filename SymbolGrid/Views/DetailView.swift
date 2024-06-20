//
//  DetailView.swift
//  SymbolGrid
//
//  Created by Dalton on 6/16/24.
//

import SwiftUI
import SFSymbolKit

struct DetailView: View {
    var body: some View {
        let dragGesture = DragGesture()
            .onChanged { value in
                self.location = value.location
//                #if os(macOS)
                self.offset = value.translation
//                #endif
            }
            .onEnded { _ in
                withAnimation {
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
#if os(macOS)
                    .offset(offset)
#endif
#if os(iOS)
                    .position(location)
#endif
                    .gesture(combined)
                    .shadow(color: shadow, radius: 3, x: offset.width, y: offset.height - 10)
                    .frame(maxWidth: .infinity, minHeight: 50, maxHeight: .infinity, alignment: .top)
                    .edgesIgnoringSafeArea(.all)
#if os(iOS)
                    .navigationTransition(.zoom(sourceID: icon.id, in: animation))
#endif
                    .onAppear {
                        print(location)
                    }
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
    var animation: Namespace.ID
    @State var color: Color = .random()
    
    @State private var selectedScale = ImageScales.medium
    @State private var selectedWeight = FontWeights.regular
    @State private var accumulatedOffset = CGSize.zero
    @State private var offset = CGSize.zero
    @State private var isDragging = false
    @State private var shadow: Color = .clear.opacity(0.5)
    @State private var fontSize = 200.0
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
    
    
#if os(iOS)
@State var location: CGPoint = CGPoint(x: UIScreen.main.bounds.midX, y: 150)
#else
@State var location: CGPoint = CGPoint(x: NSScreen.main?.frame.size.width ?? 0, y: -150)
#endif
}

#Preview {
    @Previewable @Namespace var animation
    DetailView(icon: Icon(id: "plus"), animation: animation)
}


