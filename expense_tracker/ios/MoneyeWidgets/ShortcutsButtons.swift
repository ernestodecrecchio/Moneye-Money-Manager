//
//  ShortcutsButtons.swift
//  MoneyeWidgetsExtension
//
//  Created by Ernesto De Crecchio on 22/09/24.
//

import WidgetKit
import SwiftUI

struct ShortcutsButtonsEntry: TimelineEntry {
    let date: Date
}

struct ShortcutsButtonsProvider: TimelineProvider {
    func placeholder(in context: Context) -> ShortcutsButtonsEntry {
        ShortcutsButtonsEntry(date: Date())
    }
    
    func getSnapshot(in context: Context, completion: @escaping (ShortcutsButtonsEntry) -> Void) {
        let entry: ShortcutsButtonsEntry
        
        if context.isPreview {
            entry = placeholder(in: context)
        } else {
            entry = ShortcutsButtonsEntry(date: Date())
        }
        
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> Void) {
        getSnapshot(in: context) { (entry) in
            let timeline = Timeline(entries: [entry], policy: .atEnd)
            completion(timeline)
        }
    }
}

struct ShortcutsButtonsEntryView: View {
    @State var entry: ShortcutsButtonsProvider.Entry
    
    var body: some View {
        return VStack(
            alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/,
            spacing: 20,
            content: {
                Link(destination: URL.init(string: "moneye://openNewTransactionPage?homeWidget&income=0")!) {
                    Button {} label: {
                        Text(NSLocalizedString("Expense", comment: "Button label to add an expense transaction"))
                            .foregroundColor(.widgetBackground)
                            .frame(maxWidth: .infinity)
                            .font(Font.custom("Ubuntu", size: 20))
                            .fontWeight(.light)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.white)
                }
                
                Link(destination: URL.init(string: "moneye://openNewTransactionPage?homeWidget&income=0")!) {
                    Button {} label: {
                        Text(NSLocalizedString("Income", comment: "Button label to add an income transaction"))
                                .foregroundColor(.widgetBackground)
                                .frame(maxWidth: .infinity)
                                .font(Font.custom("Ubuntu", size: 20))
                                .fontWeight(.light)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.white)
                }
            }
        )
    }
}

struct ShortcutsButtonsWidget: Widget {
    let kind: String = "ShortcutsButtonsWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: ShortcutsButtonsProvider()) { entry in
            if #available(iOS 17.0, *) {
                ShortcutsButtonsEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
                    .containerBackground(for: .widget) {
                        Color(.widgetBackground)
                    }
            } else {
                ShortcutsButtonsEntryView(entry: entry)
                    .padding()
                    .containerBackground(for: .widget) {
                        Color(.widgetBackground)
                    }
            }
        }
        .configurationDisplayName(NSLocalizedString("ShortcutButtonsWidgetTitle", comment: "Title for shortcut buttons widget"))
        .description(NSLocalizedString("ShortcutButtonsWidgetDescription", comment: "Description for shortcut buttons widget"))
        .supportedFamilies([.systemSmall])
    }
}

#Preview(as: .systemSmall) {
    ShortcutsButtonsWidget()
} timeline: {
    ShortcutsButtonsEntry(date: .now)
}

