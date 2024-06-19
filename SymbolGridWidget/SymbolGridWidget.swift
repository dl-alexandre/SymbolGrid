//
//  SymbolGridWidget.swift
//  SymbolGridWidget
//
//  Created by Dalton on 6/18/24.
//

import WidgetKit
import SwiftUI

struct Provider: AppIntentTimelineProvider {
    @AppStorage("systemName") var systemName = "minus"
    
    func placeholder(in context: Context) -> IconEntry {
        IconEntry(date: Date(), icon: systemName, configuration: ConfigurationAppIntent())
    }

    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> IconEntry {
        IconEntry(date: Date(), icon: systemName, configuration: configuration)
    }
    
    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<IconEntry> {
        var entries: [IconEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for dayOffset in 0 ..< 1 {
            let entryDate = Calendar.current.date(byAdding: .day, value: dayOffset, to: currentDate)!
            let entry = IconEntry(date: entryDate, icon: systemName, configuration: configuration)
            entries.append(entry)
        }

        return Timeline(entries: entries, policy: .atEnd)
    }

//    func relevances() async -> WidgetRelevances<ConfigurationAppIntent> {
//        // Generate a list containing the contexts this widget is relevant in.
//    }
}

struct IconEntry: TimelineEntry {
    let date: Date
    let icon: String
    let configuration: ConfigurationAppIntent
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationAppIntent
}

struct SymbolGridWidgetEntryView : View {
    var entry: Provider.Entry
    
    
    var icon = "plus"
    
    var body: some View {
        Image(systemName: entry.icon)
        
        Text(icon)
        Text(entry.date, style: .time)

        Text("Favorite Emoji:")
        Text(entry.configuration.favoriteEmoji)
    }
}



struct SymbolGridWidget: Widget {
    let kind: String = "SymbolGridWidget"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: ConfigurationAppIntent.self, provider: Provider()) { entry in
            SymbolGridWidgetEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
        .supportedFamilies([.systemSmall])
    }
}

extension ConfigurationAppIntent {
    fileprivate static var smiley: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        intent.favoriteEmoji = "😀"
        return intent
    }
    
    fileprivate static var starEyes: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        intent.favoriteEmoji = "🤩"
        return intent
    }
}

#Preview(as: .systemSmall) {
    SymbolGridWidget()
} timeline: {
    SimpleEntry(date: .now, configuration: .smiley)
    SimpleEntry(date: .now, configuration: .starEyes)
}
