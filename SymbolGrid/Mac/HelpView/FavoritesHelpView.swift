//
//  FavoritesHelpView.swift
//  SymbolGrid
//
//  Created by Dalton on 6/20/24.
//

import SwiftUI

#if os(macOS)
struct FavoritesHelpView: View {
    var body: some View {
        HStack {
            VStack {
                Text("Favorites you add show here")
            }
            Image(.favorites)
        }
    }
}
#endif

#Preview {
    FavoritesHelpView()
}
