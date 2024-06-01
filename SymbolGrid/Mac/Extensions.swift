//
//  Extensions.swift
//  SymbolGrid
//
//  Created by Dalton Alexandre on 5/31/24.
//

import SwiftUI
#if os(macOS)
extension NSApplication
{
    static var appName: String? {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as? String
    }
    
    static var appVersion: String? {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
    }
    
    static var buildVersion: String? {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String
    }
}

extension View {
    func asNSImage() -> NSImage? {
        let hostingView = NSHostingView(rootView: self)
        hostingView.setFrameSize(hostingView.fittingSize)
        guard let bitmapRep = hostingView.bitmapImageRepForCachingDisplay(in: hostingView.bounds) else { return nil }
        hostingView.cacheDisplay(in: hostingView.bounds, to: bitmapRep)
        let image = NSImage(size: hostingView.bounds.size)
        image.addRepresentation(bitmapRep)
        return image
    }
}
#endif
