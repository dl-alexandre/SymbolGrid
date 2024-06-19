//
//  SearchBarStyle.swift
//  SymbolGrid
//
//  Created by Dalton on 6/19/24.
//

import SwiftUI

struct SearchBarStyle: ViewModifier {
    func body(content: Content) -> some View {
        GrayRectangle(maxWidth: .infinity)
            .overlay {
                content
                    .font(.custom("SFProText-Bold", size: 18))
                    .foregroundColor(.primary)
            }
    }
}
