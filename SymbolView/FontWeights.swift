//
//  FontWeights.swift
//  SymbolView
//
//  Created by Dalton Alexandre on 5/27/24.
//

import SwiftUI

enum FontWeights: Int, CaseIterable {
    case black, heavy, bold, semibold, medium, regular, light, thin, ultraLight
    
    var name: String {
        switch self {
            case .black: return "Black"
            case .heavy: return "Heavy"
            case .bold: return "Bold"
            case .semibold: return "Semibold"
            case .medium: return "Medium"
            case .regular: return "Regular"
            case .light: return "Light"
            case .thin: return "Thin"
            case .ultraLight: return "UltraLight"
        }
    }
    
    var weight: Font.Weight {
        switch self {
            case .black: return .black
            case .heavy: return .heavy
            case .bold: return .bold
            case .semibold: return .semibold
            case .medium: return .medium
            case .regular: return .regular
            case .light: return .light
            case .thin: return .thin
            case .ultraLight: return .ultraLight
        }
    }
}
