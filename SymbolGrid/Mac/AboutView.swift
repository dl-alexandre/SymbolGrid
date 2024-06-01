//
//  AboutView.swift
//  SymbolGrid
//
//  Created by Dalton Alexandre on 5/31/24.
//

import SwiftUI
#if os(macOS)
struct AboutView: View {
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Text("\(NSApplication.appName ?? "1")")
                Text("Build: \(NSApplication.buildVersion ?? "1")")
                Text("Version: \(NSApplication.appVersion ?? "3")")
                Spacer()
            }
            Spacer()
        }
        .frame(minWidth: 100, minHeight: 300)
    }
}

#Preview {
    AboutView()
}
#endif

