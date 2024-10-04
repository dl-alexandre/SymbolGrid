//
//  Favorite.swift
//  SymbolGrid
//
//  Created by Dalton Alexandre on 10/2/24.
//

import SwiftUI
import SwiftData

@Model
final class Favorite {
var glyph: String = ""
 var timeStamp: Date = Date.now

    init(glyph: String = "", timeStamp: Date) {
        self.glyph = glyph
        self.timeStamp = timeStamp
    }
}
