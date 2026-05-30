//
//  TheMetWidget.swift
//  TheMetWidget
//
//  Created by Damian Ogórek on 27/05/2026.
//

import SwiftUI
import WidgetKit

struct Provider: TimelineProvider {

    let store = TheMetStore(maxIndex: 6)
    let query = "persimmon"

    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(
            date: Date(),
            object: Object.sample(isPublicDomain: true)
        )
    }

    func getSnapshot(
        in context: Context,
        completion: @escaping (SimpleEntry) -> Void
    ) {
        let entry = SimpleEntry(
            date: Date(),
            object: Object.sample(isPublicDomain: false)
        )
        completion(entry)
    }

    func getTimeline(
        in context: Context,
        completion: @escaping (Timeline<Entry>) -> Void
    ) {
        Task {
            do {
                // fetch from api
                try await store.fetchObjects(query: query)
            } catch {
                // if fails load the local data
                store.objects = [
                    Object.sample(isPublicDomain: true),
                    Object.sample(isPublicDomain: false),
                ]
            }

            // build entries only after objects are ready
            var entries: [SimpleEntry] = []
            let currentDate = Date()
            let interval = 2

            // Generate a timeline consisting of entries from store
            for index in 0..<store.objects.count {
                let entryDate = Calendar.current.date(
                    // delay type
                    byAdding: .second,
                    // change the interval -> index * two seconds apart
                    value: index * interval,
                    to: currentDate
                )!
                entries.append(
                    SimpleEntry(date: entryDate, object: store.objects[index])
                )
            }

            let timeline = Timeline(entries: entries, policy: .atEnd)
            completion(timeline)
        }
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let object: Object
}

struct TheMetWidgetEntryView: View {
    var entry: Provider.Entry

    var body: some View {
        VStack {
            Text("The Met")
                .font(.headline)
            Divider()
            if !entry.object.isPublicDomain {
                WebIndicatorView(title: entry.object.title)
                    .padding()
                    .background(.metBackground)
                    .foregroundStyle(.white)
            } else {
                DetailIndicatorView(title: entry.object.title)
                    .padding()
                    .background(.metForeground)
            }
        }
        .truncationMode(.middle)
        .fontWeight(.semibold)
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
        .supportedFamilies([.systemMedium, .systemLarge])
        .configurationDisplayName("The Met")
        .description("View objects from the Metropolitan Museum.")
    }
}

#Preview(as: .systemMedium) {
    TheMetWidget()
} timeline: {
    SimpleEntry(
        date: .now,
        object: Object.sample(isPublicDomain: true)
    )
    SimpleEntry(
        date: .now,
        object: Object.sample(isPublicDomain: false)
    )
}

#Preview(as: .systemLarge) {
    TheMetWidget()
} timeline: {
    SimpleEntry(
        date: .now,
        object: Object.sample(isPublicDomain: true)
    )
    SimpleEntry(
        date: .now,
        object: Object.sample(isPublicDomain: false)
    )
}
