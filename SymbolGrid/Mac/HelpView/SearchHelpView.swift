//
//  SearchHelpView.swift
//  SymbolGrid
//
//  Created by Dalton on 6/20/24.
//

import SwiftUI

#if os(macOS)
struct SearchHelpView: View {
    var body: some View {
        VStack {
            HStack {
                Image(.searchBar)
                Image(.searchBarClear)
                Image(.searchBarDismiss)
            }
            .padding(10)
            
            Text("SymbolGrid's Searchbar activates two buttons when focused.")
            Divider()
            Group {
                HStack {
                    Text("[ \(Image(systemName: "delete.backward")) ] clear search field")
                }
                HStack {
                    Text("[ \(Image(systemName: "xmark")) ]  close searchbar")
                }
            }
//            .padding(10)
            .frame(maxWidth: .infinity, alignment: .init(horizontal: .leading, vertical: .top))
        }
    }
}
#endif

#Preview {
    SearchHelpView()
}
