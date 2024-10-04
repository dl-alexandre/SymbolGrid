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
//        for index in offsets {
            modelContext.delete(glyph)
//        }
    }
}

//
//func removeFavorite(symbols: String...) {
////    @AppStorage("favorites") var favorites: String = "[]"
//    @State var sys = System()
//    var favoritesBinding: Binding<[String]> {
//        Binding(
//            get: { Array(jsonString: sys.favorites) ?? [] },
//            set: { sys.favorites = $0.jsonString() ?? "[]" }
//        )
//    }
//
//    var updatedFavorites = favoritesBinding.wrappedValue
//    for symbol in symbols {
//        updatedFavorites.removeAll(where: { $0 == symbol })
//        removeIconFromIndex(symbol, "com.alexandrefamilyfarm.symbols")
//    }
//    favoritesBinding.wrappedValue = updatedFavorites
//}
