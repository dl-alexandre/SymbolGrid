//
//  SettingsView.swift
//  SymbolView
//
//  Created by Dalton Alexandre on 5/29/24.
//

import SwiftUI

struct SettingsView: View {
    var body: some View {
        TabView {
            LocalizationSetting().tabItem { Label("Language", systemImage: "character") }
            FontSizeSetting().tabItem { Label("Size", systemImage: "textformat.size")}
        }.padding()
            .frame(width: 400, height: 300)
    }
}

#Preview {
    SettingsView()
}
