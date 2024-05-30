//
//  LocalizationSetting.swift
//  SymbolView
//
//  Created by Dalton Alexandre on 5/29/24.
//

import SwiftUI

struct LocalizationSetting: View {
    @AppStorage("symbol_arabic") private var arabicSetting = false
    @AppStorage("symbol_burmese") private var burmeseSetting = false
    @AppStorage("symbol_hebrew") private var hebrewSetting = false
    @AppStorage("symbol_hindi") private var hindiSetting = false
    @AppStorage("symbol_japanese") private var japaneseSetting = false
    @AppStorage("symbol_khmer") private var khmerSetting = false
    @AppStorage("symbol_korean") private var koreanSetting = false
    @AppStorage("symbol_thai") private var thaiSetting = false
    @AppStorage("symbol_chinese") private var chineseSetting = false
    
    var body: some View {
        Form {
            Text("**Special Character Localization**")
            Toggle("Arabic", isOn: $arabicSetting).keyboardShortcut("a")
            Toggle("Burmese", isOn: $burmeseSetting).keyboardShortcut("b")
            Toggle("Hebrew", isOn: $hebrewSetting).keyboardShortcut("h")
            Toggle("Hindi", isOn: $hindiSetting).keyboardShortcut("i")
            Toggle("Japanese", isOn: $japaneseSetting).keyboardShortcut("j")
            Toggle("Khmer", isOn: $khmerSetting).keyboardShortcut("m")
            Toggle("Korean", isOn: $koreanSetting).keyboardShortcut("k")
            Toggle("Thai", isOn: $thaiSetting).keyboardShortcut("t")
            Toggle("Chinese", isOn: $chineseSetting).keyboardShortcut("c")
        }
    }
}

#Preview {
    LocalizationSetting()
}
