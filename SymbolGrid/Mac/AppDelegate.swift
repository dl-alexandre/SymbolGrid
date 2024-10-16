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

    @MainActor func showAboutPanel() {
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

    @MainActor func showHelpPanel() {
        if helpBoxWindowController == nil {
            let styleMask: NSWindow.StyleMask = [.closable, .titled, .resizable]
            let window = NSWindow()
            window.styleMask = styleMask
            window.title = "\(NSApplication.appName ?? "SymbolView") Help"
            window.contentView = NSHostingView(rootView: HelpView())
            helpBoxWindowController = NSWindowController(window: window)
        }
        helpBoxWindowController?.showWindow(helpBoxWindowController?.window)
    }

    @MainActor func showMenuPanel(
        icon: Symbol,
        detailIcon: Binding<Symbol?>,
        fontSize: Binding<Double>,
        searchText: Binding<String>,
        selectedWeight: Binding<Weight>,
        selectedMode: Binding<SymbolRenderingModes>,
        showingDetail: Binding<Bool>,
        showingSearch: Binding<Bool>
    ) {
        if menuWindowController == nil {
            let styleMask: NSWindow.StyleMask = [
                .closable,
                .titled,
                .resizable
            ]
            let window = NSWindow(
                contentRect: NSRect(x: 0, y: 0, width: 400, height: 300),
                styleMask: styleMask,
                backing: .buffered,
                defer: false)
            window.styleMask = styleMask
            window.title = icon.name
            window.contentView = NSHostingView(
                rootView: SymbolSheet(
                    icon: icon,
                    detailIcon: detailIcon,
                    fontSize: fontSize,
                    searchText: searchText,
                    selectedWeight: selectedWeight,
                    selectedMode: selectedMode,
                    showingDetail: showingDetail,
                    showingSearch: showingSearch
                )
            )
            menuWindowController = NSWindowController(window: window)
        }
        menuWindowController?.showWindow(menuWindowController?.window)
    }

    @MainActor func showDetailPanel(
        icon: Symbol,
        fontSize: Binding<Double>,
        showingDetail: Binding<Bool>
    ) {
        if detailWindowController == nil {
            let styleMask: NSWindow.StyleMask = [.closable, .titled, .resizable]
            let window = NSWindow()
            window.styleMask = styleMask
            window.title = icon.name
            window.contentView = NSHostingView(
                rootView: DetailView(
                    icon: icon,
                    fontSize: fontSize,
                    showingDetail: showingDetail
                )
            )
            detailWindowController = NSWindowController(window: window)
        }
        detailWindowController?.showWindow(detailWindowController?.window)
    }
}
#endif
