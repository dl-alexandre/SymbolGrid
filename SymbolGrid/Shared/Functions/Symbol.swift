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
    icon: String,
    fontSize: Binding<Double>,
    renderMode: Binding<SymbolRenderingModes>,
    fontWeight: Binding<Weight>
) -> some View {
    @State var isHovered = false
    @State var system = ViewModel()

    Image(systemName: icon)
        .symbolRenderingMode(renderMode.wrappedValue.mode)
        .font(.system(size: fontSize.wrappedValue, weight: fontWeight.wrappedValue.weight))
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
