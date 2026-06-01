//
//  TheMetWidget.swift
//  TheMetWidget
//
//  Created by Damian Ogórek on 27/05/2026.
//

import SwiftUI
import WidgetKit

struct Provider: TimelineProvider {

    func readObjects() -> [Object] {
        var objects: [Object] = []
        let archiveURL = FileManager.getSharedContainerURL()
            .appendingPathComponent("objects.json")

        let jsonDecoder = JSONDecoder()
        if let codeData = try? Data(
            contentsOf: archiveURL
        ) {
            do {
                objects = try jsonDecoder.decode([Object].self, from: codeData)
            } catch {
                print("Provider error: Can't decode objects")
            }
        }

        return objects
    }

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

        // build entries only after objects are ready
        var entries: [SimpleEntry] = []
        let currentDate = Date()
        let interval = 2

        let objects = readObjects()
        // Generate a timeline consisting of entries from Objects File
        for index in 0..<objects.count {
            let entryDate = Calendar.current.date(
                // delay type
                byAdding: .second,
                // change the interval -> index * two seconds apart
                value: index * interval,
                to: currentDate
            )!
            let entry = SimpleEntry(date: entryDate, object: objects[index])
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
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
        .widgetURL(URL(string: "themet://\(entry.object.objectID)"))
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
