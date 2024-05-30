//
//  System.swift
//  SymbolView
//
//  Created by Dalton Alexandre on 5/29/24.
//

import SwiftUI
import SFSymbolKit
import Observation

@Observable class System {
    var symbols: [String] = decodePList()
}
