//
//  Favorite.swift
//  SymbolGrid
//
//  Created by Dalton Alexandre on 10/2/24.
//

import SwiftUI
import SwiftData

@Model
final class Favorite: Hashable, Equatable {
    var glyph: String = ""
    var timeStamp: Date = Date.now

    init(glyph: String = "", timeStamp: Date) {
        self.glyph = glyph
        self.timeStamp = timeStamp
    }

    // Hashable conformance
    func hash(into hasher: inout Hasher) {
        hasher.combine(glyph)
    }

    // Equatable conformance
    static func == (lhs: Favorite, rhs: Favorite) -> Bool {
        return lhs.glyph == rhs.glyph
    }
}
