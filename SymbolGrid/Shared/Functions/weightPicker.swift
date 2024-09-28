//
//  weightPicker.swift
//  SymbolGrid
//
//  Created by Dalton Alexandre on 9/10/24.
//

import SwiftUI
import SFSymbolKit

@ViewBuilder
func weightPicker(selectedWeight: Binding<Weight>) -> some View {
        VStack {
            Picker("", selection: selectedWeight) {
                ForEach(Weight.allCases, id: \.self) { weight in
                    Text(weight.name)
                        .font(.title)
                        .fontWeight(weight.weight)
                        .tag(weight)
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
