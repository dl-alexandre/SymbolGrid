//
//  renderPicker.swift
//  SymbolGrid
//
//  Created by Dalton Alexandre on 9/10/24.
//

import SwiftUI
import SFSymbolKit

@ViewBuilder
func renderingPicker(selectedSample: Binding<SymbolRenderingModes>) -> some View {
    VStack {
            Picker("", selection: selectedSample) {
                ForEach(SymbolRenderingModes.allCases, id: \.self) { sample in
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
        }
    }
