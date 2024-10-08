//
//  RegisterDefaults.swift
//  SymbolGrid
//
//  Created by Dalton Alexandre on 10/8/24.
//

import SwiftUI

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
