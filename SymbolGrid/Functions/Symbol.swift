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
    selected: Binding<Icon?>,
    tabModel: TabModel,
    renderMode: Binding<RenderModes>,
    fontWeight: Binding<FontWeights>
) -> some View {
    @AppStorage("systemName") var systemName = ""
    @AppStorage("fontSize") var fontSize = 50.0
    @State var isHovered = false

    Image(systemName: icon.id)
        .symbolRenderingMode(renderMode.wrappedValue.mode)
        .font(.system(size: fontSize, weight: fontWeight.wrappedValue.weight))
        .animation(.linear, value: 0.5)
        .foregroundColor(systemName == icon.id ? icon.color : Color.primary)
        .opacity(isHovered ? 0.5 : 1.0)
        .hoverEffect(.highlight)
        .onHover { hovering in
            isHovered = hovering
        }
        .onDrag {
#if os(macOS)
            let provider = NSItemProvider(
                object: (
                    Image(systemName: icon.id).asNSImage() ?? Image(systemName: "plus").asNSImage()!
                ) as NSImage
            )
#else
            let provider = NSItemProvider(object: (UIImage(systemName: icon.id) ?? UIImage(systemName: "plus")!))
#endif
            return provider

        }
        .previewLayout(.sizeThatFits)
}
