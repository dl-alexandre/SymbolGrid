//
//  SymbolViewApp.swift
//  SymbolView
//
//  Created by Dalton Alexandre on 5/24/24.
//

import SwiftUI
import SFSymbolKit

@main
struct SymbolGridApp: App {
    
    init() {
        FontRegister.load()
        registerDefaultsFromSettingsBundle()
    }
    
    @StateObject private var tabModel: TabModel = .init()
    
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(tabModel)
        }
#if os(macOS)
        .windowStyle(HiddenTitleBarWindowStyle())
#endif
#if os(macOS)
        Settings {
            SettingsView()
        }
        .commands {
            SymbolCommands()
        }
#endif
    }
}

func registerDefaultsFromSettingsBundle() {
    let defaults = UserDefaults.standard
    if let settingsBundle = Bundle.main.path(forResource: "Settings", ofType: "bundle"),
       let plistFullName = "\(settingsBundle)/Root.plist" as String?,
       let settings = NSDictionary(contentsOfFile: plistFullName),
       let preferences = settings["PreferenceSpecifiers"] as? [NSDictionary] {
        for prefSpecification in preferences {
            if let key = prefSpecification["Key"] as? String,
               let value = prefSpecification["DefaultValue"] as? String { // Fix this line
                defaults.set(value, forKey: key)
            }
        }
    }
    
}
