//
//  SearchBar.swift
//  SymbolGrid
//
//  Created by Dalton Alexandre on 6/8/24.
//

import SwiftUI

struct SearchBar: View {
    @FocusState private var searchField: Field?
    @AppStorage("showingSearch") var showingSearch = true
    
    var body: some View {
        searchBar(text: .constant("plus"), focus: $searchField, showingSearch: $showingSearch)
#if os(iOS)
            .keyboardAdaptive()
#endif
    }
}

#Preview {
    SearchBar()
}

@ViewBuilder
func searchBar(text: Binding<String>, focus: FocusState<Field?>.Binding, showingSearch: Binding<Bool>) -> some View {
    VStack {
        Spacer()
        HStack {
            Capsule()
                .fill(.ultraThickMaterial)
                .frame(maxWidth: .infinity, maxHeight: 40, alignment: .bottomLeading)
                .cornerRadius(20)
                .shadow(color: .white, radius: 1, x: -2, y: -2)
                .shadow(color: .gray, radius: 1, x: 2, y: 2)
                .overlay {
                    TextField("Search Symbols \(Image(systemName: "magnifyingglass"))", text: text)
                        .font(.custom("SFProText - Bold", size: 18))
                        .focused(focus, equals: .searchBar)
                        .foregroundColor(.primary)
                        .padding()
                }
            if focus.wrappedValue == .searchBar {
                Button {
                    withAnimation {
                        text.wrappedValue = ""
                    }
                } label: {
                    Image(systemName: "delete.backward")
                        .font(.headline)
                        .foregroundColor(.black.opacity(0.8))
                        .shadow(color: .gray, radius: 1, x: 2, y: 2)
                        .padding(.trailing, 8)
                }
                Button {
                    withAnimation {
                        showingSearch.wrappedValue = false
                        text.wrappedValue = ""
                    }
                } label: {
                    Image(systemName: "xmark")
                        .font(.headline)
                        .foregroundColor(.red.opacity(0.7))
                        .shadow(color: .red, radius: 1, x: 2, y: 2)
                        .padding(.trailing, 8)
                }.buttonBorderShape(.circle)
            }
        }.padding()
    }
}

#if os(iOS)
// Add this extension to make the view keyboard adaptive
extension View {
    func keyboardAdaptive() -> some View {
        ModifiedContent(content: self, modifier: KeyboardAdaptive())
    }
}

struct KeyboardAdaptive: ViewModifier {
    @State private var keyboardHeight: CGFloat = 0
    
    func body(content: Content) -> some View {
        content
            .padding(.bottom, keyboardHeight)
            .onAppear(perform: subscribeToKeyboardEvents)
            .onDisappear(perform: unsubscribeFromKeyboardEvents)
    }
    
    private func subscribeToKeyboardEvents() {
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) { notification in
            if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
                keyboardHeight = keyboardFrame.height
            }
        }
    }
    
    private func unsubscribeFromKeyboardEvents() {
        NotificationCenter.default.removeObserver(self)
    }
}
#endif
