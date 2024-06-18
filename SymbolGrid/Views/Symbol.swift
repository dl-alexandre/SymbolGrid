//
//  SymbolGrid.swift
//  SymbolView
//
//  Created by Dalton Alexandre on 5/24/24.
//

import SwiftUI
import SFSymbolKit

struct Symbol: View {
    @EnvironmentObject private var tabModel: TabModel
    @AppStorage("icon") var icon = ""
    @AppStorage("tab") var selectedTab = 0
    let systemName: Icon?
    let fontSize: CGFloat
    let fontWeight: FontWeights
    var renderMode: RenderModes
    @Binding var selected: Icon?
    var body: some View {
        Image(systemName: systemName!.id)
            .symbolRenderingMode(renderMode.mode)
            .font(.system(size: fontSize, weight: fontWeight.weight))
            .animation(.linear, value: 0.5)
//            .foregroundStyle(Color.random())
            .foregroundColor(icon == systemName!.id ? systemName?.color : Color.primary)
            .onTapGesture {
                withAnimation {
                    if icon.isEmpty {
                        icon = systemName!.id
                    } else if icon == systemName!.id {
                        icon = ""
                    } else {
                        icon = systemName!.id
                    }
                }
            }
            .onDrag {
#if os(macOS)
                let provider = NSItemProvider(object: (Image(systemName: systemName!.id).asNSImage() ?? Image(systemName: "plus").asNSImage()!) as NSImage)
#else
                let provider = NSItemProvider(object: (UIImage(systemName: systemName!.id) ?? UIImage(systemName: "plus")!))
#endif
                return provider
                
            }
            .previewLayout(.sizeThatFits)
            .contextMenu {
                SymbolContextMenu(icon: systemName, selected: $selected).environmentObject(tabModel)
            } preview: {
                Group {
                    Image(systemName: systemName!.id)
                        .font(.system(size: fontSize * 3))
                        .foregroundColor(.primary)
                    Text(systemName!.id)
                }.padding()
            }
            
    }
}
