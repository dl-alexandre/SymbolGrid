//
//  RemoveFavorite.swift
//  SymbolGrid
//
//  Created by Dalton Alexandre on 5/31/24.
//

import SwiftUI
import Design
import SFSymbolKit

func removeFavorite(symbols: String...) {
    @AppStorage("favorites") var favorites: String = "[]"

    var favoritesBinding: Binding<[String]> {
        Binding(
            get: { Array(jsonString: favorites) ?? [] },
            set: { favorites = $0.jsonString() ?? "[]" }
        )
    }

    var updatedFavorites = favoritesBinding.wrappedValue
    for symbol in symbols {
        updatedFavorites.removeAll(where: { $0 == symbol })
        removeIconFromIndex(symbol, "com.alexandrefamilyfarm.symbols")
    }
    favoritesBinding.wrappedValue = updatedFavorites
}
