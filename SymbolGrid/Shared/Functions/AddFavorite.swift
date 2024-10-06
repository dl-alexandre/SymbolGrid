//
//  AddFavorite.swift
//  SymbolGrid
//
//  Created by Dalton Alexandre on 5/31/24.
//

import SwiftUI
import SwiftData
import SFSymbolKit

func addFavorite(glyph: String, modelContext: ModelContext) {
            let newItem = Favorite(glyph: glyph, timeStamp: Date())
            modelContext.insert(newItem)
}
