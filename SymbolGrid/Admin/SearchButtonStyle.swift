//
//  SearchButtonStyle.swift
//  SymbolGrid
//
//  Created by Dalton on 6/19/24.
//

import SwiftUI

struct SearchButtonStyle: ButtonStyle {
    var color: Color
    func makeBody(configuration: Configuration) -> some View {
        GrayRectangle(maxWidth: 40)
            .overlay {
                configuration.label
                    .font(.headline)
                    .foregroundColor(configuration.isPressed ? .gray.opacity(0.7) : color.opacity(0.8))
                    .shadow(color: configuration.isPressed ? .gray : color, radius: 0.5, x: 1, y: 1)
            }
    }
}
