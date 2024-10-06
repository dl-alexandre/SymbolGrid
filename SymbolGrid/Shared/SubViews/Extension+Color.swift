//
//  Extension+Color.swift
//  SymbolGrid
//
//  Created by Dalton Alexandre on 10/4/24.
//

import SwiftUI

extension Color {
    func description() -> String {
#if os(iOS)
        let components = UIColor(self).cgColor.components ?? [0, 0, 0, 0]
#else
        let components = NSColor(self).cgColor.components ?? [0, 0, 0, 0]
#endif
        let red = components[0]
        let green = components[1]
        let blue = components[2]
        let alpha = components[3]

        return String(
            format: "Color(red: %.2f, green: %.2f, blue: %.2f, opacity: %.2f)",
            red,
            green,
            blue,
            alpha
        )
    }
}
