//
//  SymbolVariants.swift
//  SymbolView
//
//  Created by Dalton Alexandre on 5/27/24.
//

import SwiftUI
//#warning("provide varients")
enum SymbolVariants: Int, CaseIterable {
    case circle
    case square
    case rectangle
    case fill
    case slash
    case none
        
    var name: String {
        switch self {
            case .circle:
                return "Circle"
            case .square:
                return "Square"
            case .rectangle:
                return "Rectangle"
            case .fill:
                return "Fill"
            case .slash:
                return "Slash"
            case .none:
                return "None"
        }
    }
    
    var variant: SymbolVariants {
        switch self {
            case .circle:
                return .circle
            case .square:
                return .square
            case .rectangle:
                return .rectangle
            case .fill:
                return .fill
            case .slash:
                return .slash
            case .none:
                return .none
        }
    }
}
