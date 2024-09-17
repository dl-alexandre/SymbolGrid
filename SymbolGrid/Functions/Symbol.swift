//
//  Symbol.swift
//  SymbolGrid
//
//  Created by Dalton on 6/18/24.
//

import SwiftUI
import SFSymbolKit

@ViewBuilder
func symbol(
    icon: Icon,
    renderMode: Binding<RenderModes>,
    fontWeight: Binding<FontWeights>
) -> some View {
    @AppStorage("fontSize") var fontSize = 50.0
    @State var isHovered = false

    Image(systemName: icon.id)
        .symbolRenderingMode(renderMode.wrappedValue.mode)
        .font(.system(size: fontSize, weight: fontWeight.wrappedValue.weight))
        .animation(.linear, value: 0.5)
        .opacity(isHovered ? 0.5 : 1.0)
#if os(iOS)
        .hoverEffect(.highlight)
#endif
        .onHover { hovering in
            isHovered = hovering
        }
        .previewLayout(.sizeThatFits)
}

