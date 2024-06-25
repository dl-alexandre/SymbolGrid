//
//  DetailHelpView.swift
//  SymbolGrid
//
//  Created by Dalton on 6/20/24.
//

import SwiftUI

#if os(macOS)
struct DetailHelpView: View {
    var body: some View {
        HStack {
            VStack {
                Text("Viewing a symbol brings up a detail sheet")
                Text("where you're able to apply customizations to a symbol")
            }
            Image(.simpleDetail).aspectRatio(contentMode: .fit).padding()
        }.frame(maxWidth: .infinity, alignment: .init(horizontal: .leading, vertical: .top))
    }
}

#Preview {
    DetailHelpView()
}
#endif
