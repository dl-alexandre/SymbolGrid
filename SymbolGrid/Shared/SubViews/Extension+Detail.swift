//
//  Extension+Detail.swift
//  SymbolGrid
//
//  Created by Dalton Alexandre on 10/4/24.
//

import SwiftUI
import SFSymbolKit

extension DetailView {
    func configureShadow(showShadow: Bool, shadow: Color, offset: CGSize) -> String {
        var shadowConfig = ""

        let hex = shadow.description.trimmingCharacters(in: CharacterSet(charactersIn: "#"))
        let scanner = Scanner(string: hex)
        var rgbValue: UInt64 = 0
        if scanner.scanHexInt64(&rgbValue) {

            if showShadow {
                shadowConfig = """
        
        .shadow(
            color: Color(#colorLiteral(
                red: \(String(format: "%.1f", Double((rgbValue & 0xFF0000) >> 16))) / 255.0,
                green: \(String(format: "%.1f", Double((rgbValue & 0x00FF00) >> 8))) / 255.0,
                blue: \(String(format: "%.1f", Double(rgbValue & 0x0000FF))) / 255.0,
                alpha: \(String(format: "%.1f", Double((rgbValue & 0xFF000000) >> 24))) / 255.0)),
            radius: 3,
            x: \(String(format: "%.0f", offset.width)),
            y: \(String(format: "%.0f", offset.height)) - 10)
        """
            }
        }

        return shadowConfig
    }

    func configureColor(showForeground: Bool, color: Color) -> String {
        var colorConfig = ""

        let hex = color.description.trimmingCharacters(in: CharacterSet(charactersIn: "#"))
        let scanner = Scanner(string: hex)
        var rgbValue: UInt64 = 0
        if scanner.scanHexInt64(&rgbValue) {

            if showForeground {
                colorConfig = """
        
        .foregroundStyle(Color(#colorLiteral(
                                    red: \(String(
        format: "%.1f",
        Double((rgbValue & 0xFF0000) >> 16)
        )) / 255.0,
                                    green: \(String(
        format: "%.1f",
        Double((rgbValue & 0x00FF00) >> 8)
        )) / 255.0,
                                    blue: \(String(
        format: "%.1f",
        Double(
        rgbValue & 0x0000FF
        )
        )) / 255.0,
                                    alpha: \(String(
        format: "%.1f",
        Double((rgbValue & 0xFF000000) >> 24)
        )) / 255.0)))
        """
            }
        }

        return colorConfig
    }

    func configureFont(
        showSize: Bool,
        showWeight: Bool,
        fontSize: CGFloat,
        selectedWeight: Weight
    ) -> String {
        var fontConfig = ""

        if showSize && showWeight {
            fontConfig = """
        
            .font(.system(
                size: \(String(format: "%.0f", fontSize)),
                weight: .\(selectedWeight)))
        """
        } else if showWeight {
            fontConfig = """
        
        .font(.system(
            weight: .\(selectedWeight)))
        """
        } else if showSize {
            fontConfig = """
        
        .font(.system(
            size: \(String(format: "%.0f", fontSize)))
        """
        }

        return fontConfig
    }

    func configureScale(showScale: Bool, selectedScale: Image.Scale) -> String {
        var scaleConfig = ""

        if showScale {
            scaleConfig = """
        
        .imageScale(.\(selectedScale))
        """
        }
        return scaleConfig
    }
}
