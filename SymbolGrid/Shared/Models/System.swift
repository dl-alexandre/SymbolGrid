//
//  System.swift
//  SymbolView
//
//  Created by Dalton Alexandre on 5/29/24.
//

import SFSymbolKit
import Observation
import SwiftUI

@Observable class System {
    var sYmbols: [String] = convertSymbolsAsArrayOfStrings()
    var symbols: [Symbol] = convertSymbols()

    var arabicSetting = false
    var bengaliSetting = false // bn
    var burmeseSetting = false
    var chineseSetting = false
    var gujaratiSetting = false // gu
    var hebrewSetting = false
    var hindiSetting = false
    var japaneseSetting = false
    var kannadaSetting = false // kn
    var khmerSetting = false
    var koreanSetting = false
    var latinSetting = false // el
    var malayalamSetting = false // ml
    var manipuriSetting = false // mni
    var marathiSetting = false // mr
    var oriyaSetting = false // or
    var russianSetting = false // ru
    var santaliSetting = false // sat
    var sinhalaSetting = false // si
    var tamilSetting = false // ta
    var teluguSetting = false // te
    var thaiSetting = false
    var punjabiSetting = false // pa
}

@Observable class ViewModel {

//    var fontWeight = Weight.regular
//    var renderMode =  SymbolRenderingModes.monochrome
//    var selectedScale = Scale.medium
//    var selectedSample = SymbolRenderingModes.monochrome
//    var selectedWeight = Weight.medium
//
//
//    var fontSize = 50.0

//    var spacing: CGFloat {
//        fontSize * 0.1
//    }

//    var columns: [GridItem] {
//        [GridItem(.flexible())]
//    }

    var systemName = ""

    var selected: Symbol?

    var detailIcon: Symbol?

    var isCopied = false

    func copy() {
        isCopied.toggle()
    }

    var showingDetail = false

    func showDetail() {
        showingDetail.toggle()
    }

    var showingFavorites = false

    func showFavorites() {
        showingFavorites.toggle()
    }

//    func showWeightPicker() {
//        showingWeightPicker.toggle()
//    }
//
//    var showingWeightPicker = false

    func showSheet() {
        showingSheet.toggle()
    }

    var showingSheet = false

//    var isAnimating = true

//    func showSymbolMenu() {
//        showingSymbolMenu.toggle()
//        print("showSymbolMenu")
//    }
//
//    var showingSymbolMenu = false
}
