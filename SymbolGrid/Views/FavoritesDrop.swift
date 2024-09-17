//
//  FavoritesDrop.swift
//  SymbolGrid
//
//  Created by Dalton Alexandre on 9/14/24.
//

import SwiftUI
import UniformTypeIdentifiers

struct FavoritesDrop: View {
    @AppStorage("isDragging") var isDragging = false
    @Binding var droppedIcon: Icon?
    let isTargeted: Bool

    var body: some View {
        GeometryReader { geo in
            Image(systemName: "star")
                .background(isTargeted ? .yellow.opacity(0.2) : .gray)
                .clipShape(Circle().offset(y: 8))
                .font(.system(size: 150))
                .offset(x: geo.size.width / 2, y: geo.size.height / 2)
#if os(iOS)
                .hoverEffect(.highlight)
#endif
                .onDrop(of: [UTType.text.identifier, UTType.image.identifier], isTargeted: nil) { providers in
                    self.isDragging = false
                    if let provider = providers.first {
                        provider.loadItem(forTypeIdentifier: UTType.text.identifier, options: nil) { (item, error) in
                            if let data = item as? Data, let id = String(data: data, encoding: .utf8) {
                                // Handle the dropped text item
                                DispatchQueue.main.async {
                                    addFavorite(symbols: id)
                                }
                            }
                        }
                        provider.loadItem(forTypeIdentifier: UTType.image.identifier, options: nil) { (item, error) in
                            if let data = item as? Data, let image = UIImage(data: data) {
                                // Handle the dropped image item
                                DispatchQueue.main.async {
                                    // Process the image as needed
                                    print("Dropped image: \(image)")
                                }
                            }
                        }
                        return true
                    }
                    return false
                }
        }
    }
}

#Preview {
    FavoritesDrop(droppedIcon: .constant(Icon(id: "plus")), isTargeted: false)
}
