//
//  Extension+Color.swift
//  SymbolGrid
//
//  Created by Dalton on 6/18/24.
//

import SwiftUI

extension Color {
    static func random() -> Color {
        let red = Double.random(in: 0...1)
        let green = Double.random(in: 0...1)
        let blue = Double.random(in: 0...1)
        return Color(red: red, green: green, blue: blue)
    }
}
