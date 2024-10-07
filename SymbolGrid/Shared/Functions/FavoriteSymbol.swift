//
//  Favorite.swift
//  SymbolGrid
//
//  Created by Dalton Alexandre on 6/8/24.
//

import SwiftUI
import SwiftData
import UniformTypeIdentifiers

@ViewBuilder
func favorite(
    icon: String,
    fontSize: Double,
    selected: Binding<String?>,
    showingDetail: Binding<Bool>,
    searchText: Binding<String>,
    showingSearch: Binding<Bool>
) -> some View {
    @State var vmo = ViewModel()

    Text("\(Image(systemName: "\(icon)")) \(icon)").lineLimit(1)
        .foregroundColor(vmo.systemName == icon ? Color.secondary : Color.primary)
        .onTapGesture(count: 2) {
            withAnimation(.spring()) {
                vmo.copy()
            }
#if os(macOS)
            NSPasteboard.general.setString(systemName, forType: .string)
#else
            UIPasteboard.general .setValue(vmo.systemName.description,
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
                object: (UIImage(systemName: icon) ?? UIImage(systemName: "plus")!)
            )
#endif
            return provider

        }
        .contextMenu {
            symbolContextMenu(
                icon: icon,
                selected: selected,
                searchText: searchText,
                showingDetail: showingDetail,
                showingSearch: showingSearch
            )
        } preview: {
            Group {
                Image(systemName: icon)
                    .font(.system(size: fontSize * 3))
                    .foregroundColor(.primary)
                Text(icon)
            }.padding()
        }
}
