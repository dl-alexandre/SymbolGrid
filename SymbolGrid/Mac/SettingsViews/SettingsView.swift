//
//  SettingsView.swift
//  SymbolView
//
//  Created by Dalton Alexandre on 5/29/24.
//

import SwiftUI

struct SettingsView: View {
    var body: some View {
//        LocalizationSetting()
        TabView {
            LocalizationSetting().tabItem { Label("Language", systemImage: "character") }
            FontSizeSetting().tabItem { Label("Size", systemImage: "textformat.size")}
        }.padding()
            .frame(minWidth: 200, minHeight: 500)
    }
}

#Preview {
    SettingsView()
}
