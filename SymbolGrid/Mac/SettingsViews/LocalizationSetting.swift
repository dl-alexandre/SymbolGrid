//
//  LocalizationSetting.swift
//  SymbolView
//
//  Created by Dalton Alexandre on 5/29/24.
//

import SwiftUI

struct LocalizationSetting: View {
    @State private var system = System()

    var body: some View {
        Rectangle()
            .fill(.clear)
            .safeAreaInset(edge: .top) {
                Form {
                    Text("**Localizations**")
                    Toggle("Arabic", isOn: $system.arabicSetting).keyboardShortcut("a")
                    Toggle("Bengali", isOn: $system.bengaliSetting)
                    Toggle("Burmese", isOn: $system.burmeseSetting).keyboardShortcut("b")
                    Toggle("Chinese", isOn: $system.chineseSetting).keyboardShortcut("c")
                    Toggle("Gujarati", isOn: $system.gujaratiSetting)
                    Toggle("Hebrew", isOn: $system.hebrewSetting).keyboardShortcut("h")
                    Toggle("Hindi", isOn: $system.hindiSetting).keyboardShortcut("i")
                    Toggle("Japanese", isOn: $system.japaneseSetting).keyboardShortcut("j")
                    Toggle("Kannada", isOn: $system.kannadaSetting)
                    Toggle("Khmer", isOn: $system.khmerSetting).keyboardShortcut("m")
                    Toggle("Korean", isOn: $system.koreanSetting).keyboardShortcut("k")
                    Toggle("Latin", isOn: $system.latinSetting)
                    Toggle("Malayalam", isOn: $system.malayalamSetting)
                    Toggle("Manipuri", isOn: $system.manipuriSetting)
                    Toggle("Marathi", isOn: $system.marathiSetting)
                    Toggle("Oriya", isOn: $system.oriyaSetting)
                    Toggle("Russian", isOn: $system.russianSetting)
                    Toggle("Santali", isOn: $system.santaliSetting)
                    Toggle("Sinhala", isOn: $system.sinhalaSetting)
                    Toggle("Tamil", isOn: $system.tamilSetting)
                    Toggle("Telugu", isOn: $system.teluguSetting)
                    Toggle("Thai", isOn: $system.thaiSetting).keyboardShortcut("t")
                    Toggle("Punjabi", isOn: $system.punjabiSetting)

                }
            }
    }
}

#Preview {
    LocalizationSetting()
}
