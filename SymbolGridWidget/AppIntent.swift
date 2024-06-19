//
//  AppIntent.swift
//  SymbolGridWidget
//
//  Created by Dalton on 6/18/24.
//

import WidgetKit
import AppIntents

struct ConfigurationAppIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource { "Daily Symbol" }
    static var description: IntentDescription { "Displays a random SF Symbol daily" }

    // An example configurable parameter.
    @Parameter(title: "Favorite Symbol", default: "😃")
    var favoriteEmoji: String
}
