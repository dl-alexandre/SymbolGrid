//
//  LocalizationSetting.swift
//  SymbolView
//
//  Created by Dalton Alexandre on 5/29/24.
//

import SwiftUI

struct LocalizationSetting: View {
    @AppStorage("symbol_arabic") private var arabicSetting = false
    @AppStorage("symbol_bengali") private var bengaliSetting = false //bn
    @AppStorage("symbol_burmese") private var burmeseSetting = false
    @AppStorage("symbol_chinese") private var chineseSetting = false
    @AppStorage("symbol_gujarati") private var gujaratiSetting = false //gu
    @AppStorage("symbol_hebrew") private var hebrewSetting = false
    @AppStorage("symbol_hindi") private var hindiSetting = false
    @AppStorage("symbol_japanese") private var japaneseSetting = false
    @AppStorage("symbol_kannada") private var kannadaSetting = false //kn
    @AppStorage("symbol_khmer") private var khmerSetting = false
    @AppStorage("symbol_korean") private var koreanSetting = false
    @AppStorage("symbol_latin") private var latinSetting = false //el
    @AppStorage("symbol_malayalam") private var malayalamSetting = false //ml
    @AppStorage("symbol_manipuri") private var manipuriSetting = false //mni
    @AppStorage("symbol_oriya") private var oriyaSetting = false //or
    @AppStorage("symbol_russian") private var russianSetting = false //ru
    @AppStorage("symbol_santali") private var santaliSetting = false //sat
    @AppStorage("symbol_telugu") private var teluguSetting = false //te
    @AppStorage("symbol_thai") private var thaiSetting = false
    @AppStorage("symbol_punjabi") private var punjabiSetting = false //pa

    var body: some View {
        Form {
            Text("**Localizations**")
            Toggle("Arabic", isOn: $arabicSetting).keyboardShortcut("a")
            Toggle("Bengali", isOn: $bengaliSetting)
            Toggle("Burmese", isOn: $burmeseSetting).keyboardShortcut("b")
            Toggle("Chinese", isOn: $chineseSetting).keyboardShortcut("c")
            Toggle("Gujarati", isOn: $gujaratiSetting)
            Toggle("Hebrew", isOn: $hebrewSetting).keyboardShortcut("h")
            Toggle("Hindi", isOn: $hindiSetting).keyboardShortcut("i")
            Toggle("Japanese", isOn: $japaneseSetting).keyboardShortcut("j")
            Toggle("Kannada", isOn: $kannadaSetting)
            Toggle("Khmer", isOn: $khmerSetting).keyboardShortcut("m")
            Toggle("Korean", isOn: $koreanSetting).keyboardShortcut("k")
            Toggle("Latin", isOn: $latinSetting)
            Toggle("Malayalam", isOn: $malayalamSetting)
            Toggle("Manipuri", isOn: $manipuriSetting)
            Toggle("Oriya", isOn: $oriyaSetting)
            Toggle("Russian", isOn: $russianSetting)
            Toggle("Santali", isOn: $santaliSetting)
            Toggle("Telugu", isOn: $teluguSetting)
            Toggle("Thai", isOn: $thaiSetting).keyboardShortcut("t")
            Toggle("Punjabi", isOn: $punjabiSetting)
            
        }
    }
}

#Preview {
    LocalizationSetting()
}
