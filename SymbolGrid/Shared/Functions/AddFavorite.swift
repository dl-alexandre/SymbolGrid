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

//
//func addFavorite(symbols: String...) {
//    @State var sys = System()
//
//    var favoritesBinding: Binding<[String]> {
//        Binding(
//            get: { Array(jsonString: sys.favorites) ?? [] },
//            set: { sys.favorites = $0.jsonString() ?? "[]" }
//        )
//    }
//
//    var updatedFavorites = favoritesBinding.wrappedValue
//
//    for symbol in symbols {
//        updatedFavorites.append(symbol)
//        addIconToIndex(symbol, "com.alexandrefamilyfarm.symbols")
//    }
//    favoritesBinding.wrappedValue = updatedFavorites
//}
