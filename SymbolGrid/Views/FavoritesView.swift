//
//  Favorites.swift
//  SymbolView
//
//  Created by Dalton Alexandre on 5/30/24.
//

import SwiftUI
import SFSymbolKit
import UniformTypeIdentifiers

struct FavoritesView: View {
    @Environment(\.layoutDirection) private var layoutDirection
    @AppStorage("searchText") var searchText = ""
    @AppStorage("fontSize") var fontSize = 50.0
    @AppStorage("icon") var icon = ""
    @Binding public var renderMode: RenderModes
    @Binding public var fontWeight: FontWeights
    
    @AppStorage("favorites") private var favorites: String = "[]"
    
    
    
    var myFavorites: [String] {
        get { Array(jsonString: favorites) ?? [] }
        set { favorites = newValue.jsonString() ?? "[]" }
    }
    
    init(
        renderMode: Binding<RenderModes>,
        fontWeight: Binding<FontWeights>
    )
    {
        self._renderMode = renderMode
        self._fontWeight = fontWeight
    }
    
    private var spacing: CGFloat {
        fontSize * 0.1
    }
    
    var searchResults: [String] {
        return myFavorites.filter { key in
            // Apply search text filter if searchText is not empty
            if !searchText.isEmpty { return key.contains(searchText.lowercased()) }
            return true // Include the key if none of the above conditions are met and searchText is empty
        }
    }
    
    var body: some View {
        if myFavorites.isEmpty {
            ContentUnavailableView {
                Label("Favorites", systemImage: "star.slash")
            } description: {
                Text("Find your favorite symbols here")
            }
        } else {
            VStack {
                Text("Favorites").font(.title).bold()
                List {
                    ForEach(searchResults, id: \.hash) { systemName in
                        Favorite(systemName: systemName, icon: icon, fontSize: fontSize, fontWeight: fontWeight, renderMode: renderMode)
                        
                    }
                    .defaultScrollAnchor(.center)
                }
            }
            .coordinateSpace(name: "scroll")
            .offset(x: 0, y: searchText.isEmpty ? 0: 150)
            .edgesIgnoringSafeArea(.top)
#if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
#endif
        }
    }
}


struct Favorite: View {
    @AppStorage("favorites") private var favorites: String = "[]"
    @SceneStorage("tab") var selectedTab = 0
    var favoritesBinding: Binding<[String]> {
        Binding(
            get: { Array(jsonString: self.favorites) ?? [] },
            set: { self.favorites = $0.jsonString() ?? "[]" }
        )
    }
    
    let systemName: String
    @AppStorage("icon") var icon = ""
    //    @Binding var icon: String
    let fontSize: CGFloat
    let fontWeight: FontWeights
    var renderMode: RenderModes
    
    var body: some View {
        HStack {
            Image(systemName: systemName)
                .symbolRenderingMode(renderMode.mode)
                .font(.system(size: fontSize, weight: fontWeight.weight))
                .animation(.linear, value: 0.5).frame(width: fontSize * 1.3, height: fontSize * 1.3)
            Text(systemName).lineLimit(1).font(.system(size: fontSize/2))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
            .foregroundColor(icon == systemName ? Color.secondary : Color.primary)
            .onTapGesture {
                withAnimation {
                    if icon.isEmpty {
                        icon = systemName
                    } else if icon == systemName {
                        icon = ""
                    } else {
                        icon = systemName
                    }
                }
            }
        
            .onDrag {
#if os(macOS)
                let provider = NSItemProvider(object: (Image(systemName: systemName).asNSImage() ?? Image(systemName: "plus").asNSImage()!) as NSImage)
#else
                let provider = NSItemProvider(object: (UIImage(systemName: systemName) ?? UIImage(systemName: "plus")!))
#endif
                return provider
                
            }
            .contextMenu {
                SymbolContextMenu(icon: systemName)
            }
        
        
    }
}

extension Array where Element: Codable {
    func jsonString() -> String? {
        guard let data = try? JSONEncoder().encode(self) else { return nil }
        return String(data: data, encoding: .utf8)
    }
    
    init?(jsonString: String) {
        guard let data = jsonString.data(using: .utf8),
              let result = try? JSONDecoder().decode([Element].self, from: data) else { return nil }
        self = result
    }
}


//#Preview {
//    Favorites()
//}
