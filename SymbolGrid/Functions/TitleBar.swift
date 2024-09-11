//
//  TitleBar.swift
//  SymbolGrid
//
//  Created by Dalton Alexandre on 9/4/24.
//

import SwiftUI

@ViewBuilder
func customTitleBar(_ label: String) -> some View {
    @AppStorage("fontSize") var fontSize = 50.0
    @AppStorage("showingTitle") var showingTitle = true

    VStack {
        Capsule()
            .fill(.ultraThinMaterial)
            .frame(maxWidth: .infinity, maxHeight: 40, alignment: .trailing)
            .shadow(color: .white, radius: 1, x: -2, y: -2)
            .shadow(color: .gray, radius: 1, x: 2, y: 2)
            .overlay {
                Text(label)
                    .font(.largeTitle)
                    .foregroundColor(.gray)
                    .bold()
                    .padding()

            }
            .defaultScrollAnchor(.trailing)
            .frame(maxWidth: .infinity, alignment: .trailing)
            .padding()
            .onTapGesture(count: 1) {
                withAnimation(.spring()) {
                    showingTitle = true
                }
            }
    }
    .frame(maxHeight: .infinity, alignment: .top)
    .offset(y: fontSize + 20)
}
