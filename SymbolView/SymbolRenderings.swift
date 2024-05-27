//
//  RenderModes.swift
//  SymbolView
//
//  Created by Dalton Alexandre on 5/27/24.
//

import SwiftUI

enum SymbolRenderings: Int, CaseIterable {
        // One color to all layers in a symbol. Within a symbol, paths render in the color you specify or as a transparent shape within a color-filled path.
    case monochrome
        // Intrinsic colors to some symbols to enhance meaning. For example, the leaf symbol uses green to reflect the appearance of leaves in the physical world, whereas the trash.slash symbol uses red to signal data loss. Some multicolor symbols include layers that can receive other colors.
    case multicolor
        // One color to all layers in a symbol, varying the color’s opacity according to each layer’s hierarchical level.
    case hierarchical
        // Two or more colors to a symbol, using one color per layer. Specifying only two colors for a symbol that defines three levels of hierarchy means the secondary and tertiary layers use the same
    case palette
        // Represent a characteristic that can change over time — like capacity or strength — regardless of rendering mode. To visually communicate such a change, variable color applies color to different layers of a symbol as a value reaches different thresholds between zero and 100 percent.
    
    var name: String {
        switch self {
            case .monochrome:
                return "Monochrome"
            case .multicolor:
                return "Multicolor"
            case .hierarchical:
                return "Hierarchical"
            case .palette:
                return "Palette"
        }
    }
    
    var mode: SymbolRenderingMode {
        switch self {
            case .monochrome:
                return .monochrome
            case .multicolor:
                return .multicolor
            case .hierarchical:
                return .hierarchical
            case .palette:
                return .palette
        }
    }
}
