//
//  ViewModel.swift
//  SymbolGrid
//
//  Created by Dalton Alexandre on 10/7/24.
//

import SFSymbolKit
import Observation

@Observable class ViewModel {
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

    var showingSheet = false

    func showSheet() {
        showingSheet.toggle()
    }
}
