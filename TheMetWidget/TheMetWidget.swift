//
//  TheMetWidget.swift
//  TheMetWidget
//
//  Created by Damian Ogórek on 27/05/2026.
//

import SwiftUI
import WidgetKit

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(
            date: Date(),
            emoji: "😀",
            object: Object.sample(isPublicDomain: true)
        )
    }

    func getSnapshot(
        in context: Context,
        completion: @escaping (SimpleEntry) -> Void
    ) {
        let entry = SimpleEntry(
            date: Date(),
            emoji: "😀",
            object: Object.sample(isPublicDomain: true)
        )
        completion(entry)
    }

    func getTimeline(
        in context: Context,
        completion: @escaping (Timeline<Entry>) -> Void
    ) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date
        let currentDate = Date()
        for hourOffset in 0..<5 {
            let entryDate = Calendar.current.date(
                byAdding: .hour,
                value: hourOffset,
                to: currentDate
            )!
            let entry = SimpleEntry(
                date: entryDate,
                emoji: "😀",
                object: Object.sample(isPublicDomain: true)
            )
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }

    //    func relevances() async -> WidgetRelevances<Void> {
    //        // Generate a list containing the contexts this widget is relevant in.
    //    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let emoji: String
    let object: Object
}

struct TheMetWidgetEntryView: View {
    var entry: Provider.Entry

    var body: some View {
        VStack {
            Text("Time:")
            Text(entry.date, style: .time)

            Text("Emoji:")
            Text(entry.emoji)
        }
    }
}

struct TheMetWidget: Widget {
    let kind: String = "TheMetWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(
            kind: kind,
            provider:
                //timeline, snapshot and placeholder entries
                Provider()
        ) { entry in
            if #available(iOS 17.0, *) {
                TheMetWidgetEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                TheMetWidgetEntryView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .configurationDisplayName("The Met")
        .description("View objects from the Metropolitan Museum.")
    }
}

#Preview(as: .systemSmall) {
    TheMetWidget()
} timeline: {
    SimpleEntry(
        date: .now,
        emoji: "😀",
        object: Object.sample(isPublicDomain: true)
    )
    SimpleEntry(
        date: .now,
        emoji: "🤩",
        object: Object.sample(isPublicDomain: true)
    )
}
