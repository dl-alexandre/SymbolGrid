//
//  AppDelegate.swift
//  SymbolGrid
//
//  Created by Dalton Alexandre on 5/31/24.
//


import SwiftUI
#if os(macOS)
import AppKit

class AppDelegate: NSObject, NSApplicationDelegate {
    private var aboutBoxWindowController: NSWindowController?
    
    private var helpBoxWindowController: NSWindowController?
    
    func showAboutPanel() {
        if aboutBoxWindowController == nil {
            let styleMask: NSWindow.StyleMask = [.closable, .miniaturizable, .titled]
            let window = NSWindow()
            window.styleMask = styleMask
            window.title = "About \(NSApplication.appName ?? "SymbolView")"
            window.contentView = NSHostingView(rootView: AboutView())
            aboutBoxWindowController = NSWindowController(window: window)
        }
        aboutBoxWindowController?.showWindow(aboutBoxWindowController?.window)
    }
    
    func showHelpPanel() {
        if helpBoxWindowController == nil {
            let styleMask: NSWindow.StyleMask = [.closable, .titled, .resizable]
            let window = NSWindow()
            window.styleMask = styleMask
//            window.title = "\(NSApplication.appName ?? "SymbolView") Help"
            window.contentView = NSHostingView(rootView: HelpView())
            helpBoxWindowController = NSWindowController(window: window)
        }
        helpBoxWindowController?.showWindow(aboutBoxWindowController?.window)
    }
}
#endif
