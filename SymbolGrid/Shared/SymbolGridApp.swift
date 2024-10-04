//
//  SymbolViewApp.swift
//  SymbolView
//
//  Created by Dalton Alexandre on 5/24/24.
//

import SwiftUI
import SwiftData
import SFSymbolKit

@main
struct SymbolGridApp: App {
    init() {
        registerDefaultsFromSettingsBundle()
#if os(iOS)
        let appearance = UINavigationBar.appearance()
        appearance.setBackgroundImage(UIImage(), for: .default)
        appearance.shadowImage = UIImage()
        appearance.isTranslucent = true
#endif
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(sharedModelContainer)

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

    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Favorite.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {

            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
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
