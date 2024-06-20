//
//  GridHelpView.swift
//  SymbolGrid
//
//  Created by Dalton on 6/20/24.
//

import SwiftUI

#if os(macOS)
struct GridHelpView: View {
    var body: some View {
        VStack {

            HStack {
                VStack {
                    Text("""
To get the most from SymbolGrid:
`[control]+click` or `right click`
on individual [symbols](https://developer.apple.com/sf-symbols/) for a menu of options
"""
                    )
                    Divider()
                    Text("""
`View` shows current symbol in detail

`Add` saves symbol to your favorites

`weight` allows changing of symbol weight
`render` allows changing of rendering mode
`search` toggles the search bar
"""
                    )
                }
                Image(.simpleMenu)
                    .padding()
            }.frame(maxWidth: .infinity, alignment: .init(horizontal: .leading, vertical: .top))
        }
    }
}
#endif

#Preview {
    GridHelpView()
}
