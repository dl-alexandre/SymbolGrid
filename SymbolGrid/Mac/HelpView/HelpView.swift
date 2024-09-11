//
//  HelpView.swift
//  SymbolGrid
//
//  Created by Dalton on 6/20/24.
//

import SwiftUI
#if os(macOS)
struct HelpView: View {
    var body: some View {
        TabView {
            GridHelpView().tabItem { Label("Grid", systemImage: "square.grid.3x3") }
            SearchHelpView().tabItem { Label("Search", systemImage: "magnifingglass")}
            DetailHelpView().tabItem { Label("Detail", systemImage: "drop.halffull")}
            FavoritesHelpView().tabItem { Label("Favorites", systemImage: "star.fill")}
        }
        .tableStyle(.inset)
        .frame(minWidth: 750, minHeight: 350)
    }
}

#Preview {
    HelpView()
}
#endif
