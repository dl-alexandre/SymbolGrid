//
//  FontSizeSetting.swift
//  SymbolView
//
//  Created by Dalton Alexandre on 5/29/24.
//

import SwiftUI

struct FontSizeSetting: View {
    @AppStorage("fontsize") var fontSize = 50.0
    @State private var linearValue: Double = log10(50) // Linear slider value
    var exponentialValue: Double {
        get {
                // Convert the linear slider value to an exponential value
            pow(10, linearValue)
        }
        set {
                // Convert the new exponential value back to a linear slider value
            linearValue = log10(newValue)
            fontSize = newValue
        }
    }
    
    var body: some View {
        VStack {
            Slider(value: Binding(
                get: { self.linearValue },
                set: { newValue in
                    self.linearValue = newValue
                    self.fontSize = pow(10, newValue)
                }
            ), in: log10(9)...log10(2000))
            Text("Grid Size: \(fontSize, specifier: "%.2f")")
            
            HStack {
                Button {
                    fontSize = max(9, fontSize - 5)
                } label: {
                    Label("Smaller", systemImage: "minus")
                }.keyboardShortcut("-")
                Button {
                    fontSize = min(2000, fontSize + 10)
                } label: {
                    Label("Larger", systemImage: "plus")
                }.keyboardShortcut("=")
            }
        }
    }
}


#Preview {
    FontSizeSetting()
}
