//
//  Icon.swift
//  SymbolGrid
//
//  Created by Dalton on 6/16/24.
//

#if os(iOS)
import UIKit
import SwiftUI
import UniformTypeIdentifiers
import Foundation

struct Icon: Identifiable, Equatable, Transferable, Codable, Hashable {
    var id: String
    var color: Color
    var uiColor: UIColor?

    init(id: String, color: Color, uiColor: UIColor?) {
        self.id = id
        self.color = color
        self.uiColor = UIColor(color)
    }

    // Define the type of data that will be transferred
    static var transferRepresentation: some TransferRepresentation {
        CodableRepresentation(contentType: .icon)
    }

    // Custom decoding for Color
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        let colorData = try container.decode(Data.self, forKey: .color)
        uiColor = try NSKeyedUnarchiver.unarchivedObject(ofClass: UIColor.self, from: colorData) ?? .clear
        color = Color(uiColor!)
    }

    // Custom encoding for Color
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        let colorData = try NSKeyedArchiver.archivedData(withRootObject: uiColor!, requiringSecureCoding: false)
        try container.encode(colorData, forKey: .color)
    }

    enum CodingKeys: String, CodingKey {
        case id
        case color
    }
}

// Define a custom content type for your Icon
extension UTType {
    static var icon: UTType {
        UTType(exportedAs: "com.alexandrefamilyfarm.symbols")
    }
}
#else
import SwiftUI
import UniformTypeIdentifiers

struct Icon: Identifiable, Equatable, Transferable, Codable {
    var id: String
    var color: Color
    var uiColor: NSColor?

    init(id: String, color: Color, uiColor: NSColor?) {
        self.id = id
        self.color = color
        self.uiColor = NSColor(color)
    }

    // Define the type of data that will be transferred
    static var transferRepresentation: some TransferRepresentation {
        CodableRepresentation(contentType: .icon)
    }

    // Custom decoding for Color
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        let colorData = try container.decode(Data.self, forKey: .color)
        uiColor = try NSKeyedUnarchiver.unarchivedObject(ofClass: NSColor.self, from: colorData) ?? .clear
        color = Color(uiColor!)
    }

    // Custom encoding for Color
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        let colorData = try NSKeyedArchiver.archivedData(withRootObject: uiColor!, requiringSecureCoding: false)
        try container.encode(colorData, forKey: .color)
    }

    enum CodingKeys: String, CodingKey {
        case id
        case color
    }
}

// Define a custom content type for your Icon
extension UTType {
    static var icon: UTType {
        UTType(exportedAs: "com.alexandrefamilyfarm.symbols")
    }
}
#endif
