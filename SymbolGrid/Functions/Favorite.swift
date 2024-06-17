//
//  Favorite.swift
//  SymbolGrid
//
//  Created by Dalton Alexandre on 6/8/24.
//

import SwiftUI
import UniformTypeIdentifiers

@ViewBuilder
func favorite(systemName: Icon, font: Font, icon: String, isCopied: Binding<Bool>, selected: Binding<Icon?>, tabModel: TabModel, fontSize: CGFloat) -> some View {
    Text("\(Image(systemName: "\(systemName.id)")) \(systemName.id)").lineLimit(1)
        .font(font)
        .foregroundColor(icon == systemName.id ? Color.secondary : Color.primary)
        .onTapGesture(count: 2) {
            withAnimation(.spring()) {
                isCopied.wrappedValue.toggle()
            }
#if os(macOS)
            NSPasteboard.general.setString(icon, forType: .string)
#else
            UIPasteboard.general .setValue(icon.description,
                                           forPasteboardType: UTType.plainText .identifier)
#endif
        }
        .onDrag {
#if os(macOS)
            let provider = NSItemProvider(object: (Image(systemName: systemName.id).asNSImage() ?? Image(systemName: "plus").asNSImage()!) as NSImage)
#else
            let provider = NSItemProvider(object: (UIImage(systemName: systemName.id) ?? UIImage(systemName: "plus")!))
#endif
            return provider
            
        }
        .contextMenu {
            SymbolContextMenu(icon: systemName, selected: selected).environmentObject(tabModel)
        } preview: {
            Group {
                Image(systemName: systemName.id)
                    .font(.system(size: fontSize * 3))
                    .foregroundColor(.primary)
                Text(systemName.id)
            }.padding()
        }
}
