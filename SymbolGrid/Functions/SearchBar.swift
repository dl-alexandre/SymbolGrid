//
//  SearchBar.swift
//  SymbolGrid
//
//  Created by Dalton Alexandre on 6/8/24.
//

import SwiftUI
import Design

struct SearchBar: View {
    @FocusState private var searchField: Field?
    @FocusState private var isSearchFieldFocused: Bool
    @AppStorage("showingSearch") var showingSearch = true

    var body: some View {
        searchBar(
            text: .constant("plus"),
            focus: $searchField,
            isSearchFieldFocused: $isSearchFieldFocused,
            showingSearch: $showingSearch
        )
#if os(iOS)
            .keyboardAdaptive()
#endif
    }
}

#Preview {
    SearchBar()
}

@ViewBuilder
func searchBar(
    text: Binding<String>,
    focus: FocusState<Field?>.Binding,
    isSearchFieldFocused: FocusState<Bool>.Binding,
    showingSearch: Binding<Bool>
) -> some View {
    VStack {
        Spacer()
        HStack {
            TextField("Search Symbols \(Image(systemName: "magnifyingglass"))", text: text)
                .modifier(SearchBarStyle())
                .focused(isSearchFieldFocused)
                .focused(focus, equals: .searchBar)
            if focus.wrappedValue == .searchBar {
                Button {
                    withAnimation {
                        text.wrappedValue = ""
                    }
                } label: {
                    Image(systemName: "delete.backward")
                }
                .buttonStyle(SearchButtonStyle(color: .gray))
                Button {
                    withAnimation {
                        showingSearch.wrappedValue = false
                        text.wrappedValue = ""
                    }
                } label: {
                    Image(systemName: "xmark")
                }
                .buttonStyle(SearchButtonStyle(color: .red))
            }
        }
        .padding(2)
    }
}

@ViewBuilder
func searchBar2(text: Binding<String>, focus: FocusState<Field?>.Binding) -> some View {
    VStack {
        HStack {
            TextField("Search Symbols \(Image(systemName: "magnifyingglass"))", text: text)
                .modifier(SearchBarStyle())
                .focused(focus, equals: .searchBar)
            if focus.wrappedValue == .searchBar {
                Button {
                    withAnimation {
                        text.wrappedValue = ""
                    }
                } label: {
                    Image(systemName: "delete.backward")
                }
                .buttonStyle(SearchButtonStyle(color: .gray))
            }
        }
        .padding(2)
    }
}
