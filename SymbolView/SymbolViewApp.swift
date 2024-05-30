//
//  SymbolViewApp.swift
//  SymbolView
//
//  Created by Dalton Alexandre on 5/24/24.
//

import SwiftUI

@main
struct SymbolViewApp: App {
#if os(macOS)
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    #endif
    
    @State private var isActive: Bool = true
    @State private var system = System()
    var body: some Scene {
        WindowGroup {
            if isActive {
                LoadingView(isActive: $isActive)
            } else {
                ContentView(symbols: system.symbols)
                    .transition(.move(edge: .bottom))
            }
           
        }
#if os(macOS)
        Settings {
            SettingsView()
        }
        .commands {
            SidebarCommands()
            CommandMenu("Symbols") {
                Button {
                    showSearch()
                } label: {
                    Label("Search", systemImage: "magnifyingglass")
                }.keyboardShortcut("s")
                Button {
                    clearSearch()
                } label: {
                    Label("Clear", systemImage: "delete.left")
                }.keyboardShortcut(.escape, modifiers: [])
                Button {
                    fontSize = max(9, fontSize - 5)
                } label: {
                    Label("Smaller", systemImage: "minus")
                }.keyboardShortcut("-")
                Button {
                    fontSize = min(2000, fontSize + 10)
                } label: {
                    Label("Larger", systemImage: "plus")
                }.keyboardShortcut("=")
            }
            CommandGroup(replacing: CommandGroupPlacement.appInfo) {
                Button(action: {
                    appDelegate.showAboutPanel()
                }) {
                    Text("About \(NSApplication.appName ?? "SymbolView")")
                }
            }
        }
#endif
    }
    @AppStorage("showingSearch") var showingSearch = false
    @AppStorage("searchText") var searchText = ""
    @AppStorage("fontSize") var fontSize = 50.0
    func showSearch() { showingSearch.toggle() }
    
    func clearSearch() {
        showingSearch = false
        searchText = ""
    }
}
#if os(macOS)
import AppKit
class AppDelegate: NSObject, NSApplicationDelegate {
    private var aboutBoxWindowController: NSWindowController?
    
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
}

struct AboutView: View {
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Text("\(NSApplication.appName ?? "1")")
                Text("Build: \(NSApplication.buildVersion ?? "1")")
                Text("Version: \(NSApplication.appVersion ?? "3")")
                Spacer()
            }
            Spacer()
        }
        .frame(minWidth: 100, minHeight: 300)
    }
}


public extension NSApplication
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
#endif

//    public func decodePList() -> [String] {
//            // Get the URL of the plist file in the main bundle
//        guard let fileURL = Bundle.main.url(forResource: "symbol_categories", withExtension: "plist") else {
//            fatalError("Can't find symbol_categories.plist")
//        }
//            // Get the data from the plist file
//        guard let data = try? Data(contentsOf: fileURL) else {
//            fatalError("Can't read data from symbol_categories.plist")
//        }
//            // Create a PropertyListDecoder instance
//        let decoder = PropertyListDecoder()
//            // Decode the data into a dictionary of type [String: String]
//        guard let dict = try? decoder.decode([String: [String]].self, from: data) else {
//            fatalError("Can't decode data from symbol_categories.plist")
//        }
//        
//        let symbols = dict.keys
//        
//        return Array(symbols)
//    }





