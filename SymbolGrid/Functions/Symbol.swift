//
//  Symbol.swift
//  SymbolGrid
//
//  Created by Dalton on 6/18/24.
//

import SwiftUI
import SFSymbolKit

@ViewBuilder
func symbol(icon: Icon, selected: Binding<Icon?>, tabModel: TabModel, renderMode: Binding<RenderModes>, fontWeight: Binding<FontWeights>) -> some View {
    @AppStorage("systemName") var systemName = ""
    @AppStorage("fontSize") var fontSize = 50.0
    
    Image(systemName: icon.id)
        .symbolRenderingMode(renderMode.wrappedValue.mode)
        .font(.system(size: fontSize, weight: fontWeight.wrappedValue.weight))
        .animation(.linear, value: 0.5)
        .foregroundColor(systemName == icon.id ? icon.color : Color.primary)
        .onTapGesture {
            withAnimation {
//#if os(macOS)
//                if selected.wrappedValue == icon {
//                    selected.wrappedValue = nil
//                } else {
//                    selected.wrappedValue = icon
//                }
//#else
                if systemName.isEmpty {
                    systemName = icon.id
                } else if systemName == icon.id {
                    systemName = ""
                } else {
                    systemName = icon.id
                }
//#endif
                print(icon.id)
                print(systemName)
            }
        }
        .onDrag {
#if os(macOS)
            let provider = NSItemProvider(object: (Image(systemName: icon.id).asNSImage() ?? Image(systemName: "plus").asNSImage()!) as NSImage)
#else
            let provider = NSItemProvider(object: (UIImage(systemName: icon.id) ?? UIImage(systemName: "plus")!))
#endif
            return provider
            
        }
        .previewLayout(.sizeThatFits)
        .contextMenu {
            symbolContextMenu(icon: icon, selected: selected, tabModel: tabModel)
        } preview: {
            Group {
                Image(systemName: icon.id)
                    .font(.system(size: fontSize * 3))
                    .foregroundColor(.primary)
                Text(icon.id)
            }.padding()
        }
}
