//
//  SearchBar.swift
//  SymbolGrid
//
//  Created by Dalton Alexandre on 6/8/24.
//

import SwiftUI

struct SearchBar: View {
    @FocusState private var searchField: Field?
    var body: some View {
        searchBar(text: .constant("plus"), focus: $searchField)
    }
}

#Preview {
    SearchBar()
}

@ViewBuilder
func searchBar(text: Binding<String>, focus: FocusState<Field?>.Binding) -> some View {
    VStack {
        Spacer()
        Capsule()
            .fill(.ultraThickMaterial)
            .frame(maxWidth: .infinity, maxHeight: 40, alignment: .bottomLeading)
            .cornerRadius(20)
            .overlay {
                TextField("Search Symbols \(Image(systemName: "magnifyingglass"))", text: text)
                    .font(.custom("SFProText - Bold", size: 18))
                    .focused(focus, equals: .searchBar)
                    .foregroundColor(.primary)
                    .padding()
            }.padding()
    }
    }
