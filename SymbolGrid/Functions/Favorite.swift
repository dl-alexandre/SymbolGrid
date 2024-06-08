//
//  Favorite.swift
//  SymbolGrid
//
//  Created by Dalton Alexandre on 6/8/24.
//

import SwiftUI
import UniformTypeIdentifiers

@ViewBuilder
func favorite(systemName: String, font: Font, icon: String, isCopied: Binding<Bool>) -> some View {
    Text("\(Image(systemName: "\(systemName)")) \(systemName)").lineLimit(1)
        .font(font)
        .foregroundColor(icon == systemName ? Color.secondary : Color.primary)
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
            let provider = NSItemProvider(object: (Image(systemName: systemName).asNSImage() ?? Image(systemName: "plus").asNSImage()!) as NSImage)
#else
            let provider = NSItemProvider(object: (UIImage(systemName: systemName) ?? UIImage(systemName: "plus")!))
#endif
            return provider
            
        }
}
