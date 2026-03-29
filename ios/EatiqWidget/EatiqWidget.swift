//
//  EatiqWidget.swift
//  EatiqWidget
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> EatiqEntry {
        EatiqEntry(date: Date(), calories: 0, water: 0.0, streak: 0)
    }

    func getSnapshot(in context: Context, completion: @escaping (EatiqEntry) -> ()) {
        let entry = EatiqEntry(date: Date(), calories: 1200, water: 1.5, streak: 3)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let userDefaults = UserDefaults(suiteName: "group.com.ai.eatiq")
        let calories = userDefaults?.integer(forKey: "calories") ?? 0
        let water = userDefaults?.double(forKey: "water") ?? 0.0
        let streak = userDefaults?.integer(forKey: "streak") ?? 0

        let entry = EatiqEntry(date: Date(), calories: calories, water: water, streak: streak)
        let nextUpdate = Calendar.current.date(byAdding: .hour, value: 1, to: Date())!
        let timeline = Timeline(entries: [entry], policy: .after(nextUpdate))
        completion(timeline)
    }
}

struct EatiqEntry: TimelineEntry {
    let date: Date
    let calories: Int
    let water: Double
    let streak: Int
}

struct EatiqWidgetEntryView: View {
    var entry: Provider.Entry
    @Environment(\.widgetFamily) var family

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                HStack(spacing: 2) {
                    Text("🔥").font(.caption2)
                    Text("\(entry.streak)")
                        .font(.caption).bold()
                        .foregroundColor(.orange)
                }
                .padding(.horizontal, 6).padding(.vertical, 4)
                .background(Color.orange.opacity(0.15))
                .cornerRadius(8)

                Spacer()

                HStack(spacing: 2) {
                    Text("💧").font(.caption2)
                    Text(String(format: "%.1fL", entry.water))
                        .font(.caption).bold()
                        .foregroundColor(.cyan)
                }
                .padding(.horizontal, 6).padding(.vertical, 4)
                .background(Color.cyan.opacity(0.15))
                .cornerRadius(8)
            }

            Spacer()

            VStack(alignment: .leading, spacing: 0) {
                Text("\(entry.calories)")
                    .font(.system(size: 34, weight: .heavy, design: .rounded))
                    .foregroundColor(Color(red: 0.76, green: 0.96, blue: 0.23))
                    .minimumScaleFactor(0.5)
                Text("kcal aldın")
                    .font(.caption).fontWeight(.semibold)
                    .foregroundColor(.gray)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .containerBackground(Color(red: 0.05, green: 0.05, blue: 0.05), for: .widget)
    }
}

struct EatiqWidget: Widget {
    let kind: String = "EatiqWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            EatiqWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("eatiq Özet")
        .description("Günlük kalori, su ve serin.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}
