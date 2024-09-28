//
//  Favorite.swift
//  SymbolGrid
//
//  Created by Dalton Alexandre on 6/8/24.
//

import SwiftUI
import UniformTypeIdentifiers

@ViewBuilder
func favorite(
    icon: Icon,
    isCopied: Binding<Bool>,
    selected: Binding<Icon?>
) -> some View {
    @AppStorage("systemName") var systemName = ""
    @AppStorage("fontSize") var fontSize = 50.0

    Text("\(Image(systemName: "\(icon.id)")) \(icon.id)").lineLimit(1)
        .foregroundColor(systemName == icon.id ? Color.secondary : Color.primary)
        .onTapGesture(count: 2) {
            withAnimation(.spring()) {
                isCopied.wrappedValue.toggle()
            }
#if os(macOS)
            NSPasteboard.general.setString(systemName, forType: .string)
#else
            UIPasteboard.general .setValue(systemName.description,
                                           forPasteboardType: UTType.plainText .identifier)
#endif
        }
        .onDrag {
#if os(macOS)
            let provider = NSItemProvider(
                object: (
                    Image(systemName: icon.id).asNSImage() ?? Image(systemName: "plus").asNSImage()!
                ) as NSImage
            )
#else
            let provider = NSItemProvider(
                object: (UIImage(systemName: icon.id) ?? UIImage(systemName: "plus")!)
            )
#endif
            return provider

        }
        .contextMenu {
            symbolContextMenu(icon: icon, selected: selected/*, tabModel: tabModel*/)
        } preview: {
            Group {
                Image(systemName: icon.id)
                    .font(.system(size: fontSize * 3))
                    .foregroundColor(.primary)
                Text(icon.id)
            }.padding()
        }
}
