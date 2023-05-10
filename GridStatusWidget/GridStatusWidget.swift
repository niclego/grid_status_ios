//
//  GridStatusWidget.swift
//  GridStatusWidget
//
//  Created by Nicolas Le Gorrec on 4/30/23.
//

import WidgetKit
import SwiftUI
import Intents
import GridStatusCommonUI

struct Provider: IntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: ConfigurationIntent())
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), configuration: configuration)
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let timeline = Timeline(entries: [SimpleEntry(date: Date(), configuration: ConfigurationIntent())], policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationIntent
}

struct GridStatusWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        StackedAreaChartCard(config: .example, timeZone: Date.timeZoneFor(isoId: "caiso") ?? .current)
    }
}

struct GridStatusWidget: Widget {
    let kind: String = "GridStatusWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            GridStatusWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
        .supportedFamilies([.systemMedium])
    }
}

struct GridStatusWidget_Previews: PreviewProvider {
    static var previews: some View {
        GridStatusWidgetEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
