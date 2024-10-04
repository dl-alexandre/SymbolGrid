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
    var symbols: [String] = decodePList()

    var searchResults: [String] {
        return symbols.filter { key in
            if !arabicSetting && key.hasSuffix(".ar") { return false }
            if !bengaliSetting && key.hasSuffix(".bn") { return false }
            if !burmeseSetting && key.hasSuffix(".my") { return false }
            if !chineseSetting && key.hasSuffix(".zh") { return false }
            if !gujaratiSetting && key.hasSuffix(".gu") { return false }
            if !hebrewSetting && key.hasSuffix(".he") { return false }
            if !hindiSetting && key.hasSuffix(".hi") { return false }
            if !japaneseSetting && key.hasSuffix(".ja") { return false }
            if !kannadaSetting && key.hasSuffix(".kn") { return false }
            if !khmerSetting && key.hasSuffix(".km") { return false }
            if !koreanSetting && key.hasSuffix(".ko") { return false }
            if !latinSetting && key.hasSuffix(".el") { return false }
            if !malayalamSetting && key.hasSuffix(".ml") { return false }
            if !manipuriSetting && key.hasSuffix(".mni") { return false }
            if !marathiSetting && key.hasSuffix(".mr") { return false }
            if !oriyaSetting && key.hasSuffix(".or") { return false }
            if !russianSetting && key.hasSuffix(".ru") { return false }
            if !santaliSetting && key.hasSuffix(".sat") { return false }
            if !sinhalaSetting && key.hasSuffix(".si") { return false }
            if !tamilSetting && key.hasSuffix(".ta") { return false }
            if !teluguSetting && key.hasSuffix(".te") { return false }
            if !thaiSetting && key.hasSuffix(".th") { return false }
            if !punjabiSetting && key.hasSuffix(".pa") { return false }

            // Apply search text filter if searchText is not empty
            if !searchText.isEmpty { return key.contains(searchText.lowercased()) }
            return true // Include the key if none of the above conditions are met and searchText is empty
        }
    }

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

    var searchText = ""

//    func clearSearch() {
//        showingSearch = false
//        searchText = ""
//    }

//    func showSearch() {
//        showingSearch.toggle()
//    }

//    var showingSearch = false
}

@Observable class ViewModel {

    var fontWeight = Weight.regular
    var renderMode =  SymbolRenderingModes.monochrome
    var selectedScale = Scale.medium
    var selectedSample = SymbolRenderingModes.monochrome
    var selectedWeight = Weight.medium


    var fontSize = 50.0

    var spacing: CGFloat {
        fontSize * 0.1
    }

    var columns: [GridItem] {
        [GridItem(.flexible())]
    }

    var systemName = ""

    var selected: String?

    var detailIcon: String?

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

    func showSymbolMenu() {
        showingSymbolMenu.toggle()
        print("showSymbolMenu")
    }

    var showingSymbolMenu = false
}
