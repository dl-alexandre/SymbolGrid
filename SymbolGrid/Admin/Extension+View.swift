//
//  KeyboardAdaptive.swift
//  SymbolGrid
//
//  Created by Dalton on 6/19/24.
//

import SwiftUI

extension View {
    func keyboardAdaptive() -> some View {
        ModifiedContent(content: self, modifier: KeyboardAdaptive())
    }
}

