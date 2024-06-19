//
//  GrayRectangle.swift
//  SymbolGrid
//
//  Created by Dalton on 6/19/24.
//

import SwiftUI

struct GrayRectangle: View {
    var maxWidth: CGFloat
    
    var body: some View {
        Rectangle()
            .fill(.ultraThickMaterial)
            .frame(maxWidth: maxWidth, maxHeight: 40)
            .shadow(color: .white, radius: 1, x: -2, y: -2)
            .shadow(color: .gray, radius: 1, x: 2, y: 2)
            .cornerRadius(2)
    }
}
