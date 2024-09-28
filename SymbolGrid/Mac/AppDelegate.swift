//
//  AppDelegate.swift
//  SymbolGrid
//
//  Created by Dalton Alexandre on 5/31/24.
//

import SwiftUI
#if os(macOS)
import AppKit
import Design
import SFSymbolKit

class AppDelegate: NSObject, NSApplicationDelegate {
    private var aboutBoxWindowController: NSWindowController?

    private var helpBoxWindowController: NSWindowController?

    private var menuWindowController: NSWindowController?

    private var detailWindowController: NSWindowController?

    private var tabViewController: NSTabViewController?

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
        helpBoxWindowController?.showWindow(helpBoxWindowController?.window)
    }

    func showMenuPanel(
        icon: Icon,
        detailIcon: Binding<Icon?>,
        selectedWeight: Binding<Weight>,
        selectedSample: Binding<SymbolRenderingModes>,
        showInspector: Binding<Bool>
    ) {
        if menuWindowController == nil {
            let styleMask: NSWindow.StyleMask = [
                .closable,
                .titled,
                .resizable
            ]
            let window = NSWindow()
            window.styleMask = styleMask
            window.title = icon.id
            //            window.title = "\(NSApplication.appName ?? "SymbolView") Help"
            window.contentView = NSHostingView(
                rootView: SymbolSheet(
                    icon: icon,
                    detailIcon: detailIcon,
                    selectedWeight: selectedWeight,
                    selectedSample: selectedSample,
                    showInspector: showInspector
                )
            )
            menuWindowController = NSWindowController(window: window)
        }
        menuWindowController?.showWindow(menuWindowController?.window)
    }

    func showDetailPanel(icon: Icon) {
        if detailWindowController == nil {
            let styleMask: NSWindow.StyleMask = [.closable, .titled, .resizable]
            let window = NSWindow()
            window.styleMask = styleMask
            window.title = icon.id
            //            window.title = "\(NSApplication.appName ?? "SymbolView") Help"
            window.contentView = NSHostingView(rootView: DetailView(icon: icon, color: icon.color))
            detailWindowController = NSWindowController(window: window)
        }
        detailWindowController?.showWindow(detailWindowController?.window)
    }
}
#endif
