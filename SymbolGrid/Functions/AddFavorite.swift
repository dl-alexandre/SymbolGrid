//
//  AddFavorite.swift
//  SymbolGrid
//
//  Created by Dalton Alexandre on 5/31/24.
//

import SwiftUI

func addFavorite(icons: String...) {
    @AppStorage("favorites") var favorites: String = "[]"
    
    var favoritesBinding: Binding<[String]> {
        Binding(
            get: { Array(jsonString: favorites) ?? [] },
            set: { favorites = $0.jsonString() ?? "[]" }
        )
    }
    
    var updatedFavorites = favoritesBinding.wrappedValue
    for icon in icons {
        updatedFavorites.append(icon)
    }
    favoritesBinding.wrappedValue = updatedFavorites
}