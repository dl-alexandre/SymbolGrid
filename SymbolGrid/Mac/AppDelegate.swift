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

    struct MenuPanelConfig {
        let icon: Symbol
        let detailIcon: Binding<Symbol?>
        let fontSize: Binding<Double>
        let searchText: Binding<String>
        let selectedWeight: Binding<Weight>
        let selectedMode: Binding<SymbolRenderingModes>
        let showingDetail: Binding<Bool>
        let showingSearch: Binding<Bool>
    }

    @MainActor func showMenuPanel(with config: MenuPanelConfig) {
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
            window.title = config.icon.name
            window.contentView = NSHostingView(
                rootView: SymbolSheet(
                    icon: config.icon,
                    detailIcon: config.detailIcon,
                    fontSize: config.fontSize,
                    searchText: config.searchText,
                    selectedWeight: config.selectedWeight,
                    selectedMode: config.selectedMode,
                    showingDetail: config.showingDetail,
                    showingSearch: config.showingSearch
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
