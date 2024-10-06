//
//  RemoveFavorite.swift
//  SymbolGrid
//
//  Created by Dalton Alexandre on 5/31/24.
//

import SwiftUI
import SwiftData
import Design
import SFSymbolKit

func deleteFavorite(glyph: Favorite, modelContext: ModelContext) {
    withAnimation {
        modelContext.delete(glyph)
    }
}
