//
//  AddFavorite.swift
//  SymbolGrid
//
//  Created by Dalton Alexandre on 5/31/24.
//

import SwiftUI
import SwiftData
import SFSymbolKit

func addFavorite(glyph: String, modelContext: ModelContext, favorites: [Favorite]) {
            let newItem = Favorite(glyph: glyph, timeStamp: Date())
    if !favorites.contains(newItem) {
        modelContext.insert(newItem)
    }
}
