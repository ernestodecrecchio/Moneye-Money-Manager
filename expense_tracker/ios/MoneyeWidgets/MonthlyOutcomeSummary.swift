//
//  MonthlyOutcomeSummary.swift
//  Runner
//
//  Created by Ernesto De Crecchio on 11/06/24.
//

import WidgetKit
import SwiftUI

struct MonthlyOutcomeSummaryProvider: TimelineProvider {
    func placeholder(in context: Context) -> Summary {
        Summary(date: Date(), title: "This month",
                outcomeValue: "-123.45€")
    }

    func getSnapshot(in context: Context, completion: @escaping (Summary) -> ()) {
        let entry: Summary
        
        if context.isPreview {
            entry = placeholder(in: context)
        } else {
            let userDefaults = UserDefaults(suiteName: "group.moneyewidget")
            
            let title = userDefaults?.string(forKey: "title") ?? "Monthly transactions"
            let outcomeValue = userDefaults?.string(forKey: "outcomeValue") ?? "0"
            
            entry = Summary(date: Date(), title: title, outcomeValue: outcomeValue)
        }
        
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        getSnapshot(in: context) { (entry) in
            let timeline = Timeline(entries: [entry], policy: .atEnd)
            completion(timeline)
        }
    }
}

struct MonthlyOutcomeSummaryEntryView : View {
    var entry: MonthlyOutcomeSummaryProvider.Entry

    var bundle: URL {
        let bundle = Bundle.main
        if bundle.bundleURL.pathExtension == "appex" {
            var url = bundle.bundleURL.deletingLastPathComponent().deletingLastPathComponent()
            url.append(component: "Frameworks/App.framework/flutter_assets")
            return url
        }
        return bundle.bundleURL
    }
    
    init(entry: MonthlyOutcomeSummaryProvider.Entry) {
        self.entry = entry
        CTFontManagerRegisterFontsForURL(bundle.appending(path: "/assets/fonts/Ubuntu-R.ttf") as CFURL, CTFontManagerScope.process, nil)
        CTFontManagerRegisterFontsForURL(bundle.appending(path: "/assets/fonts/Ubuntu-B.ttf") as CFURL, CTFontManagerScope.process, nil)
    }
    
    @Environment(\.widgetFamily) var family
   
    
    @ViewBuilder
        var body: some View {
            switch family {
            case .systemSmall:
                systemSmallWidget()
            default:
                systemSmallWidget()
            }
        }
    
    func systemSmallWidget() -> some View {
        return VStack(
            alignment: .center, spacing: 24,
            content: {
                if let title = entry.title {
                    Text(title)
                        .font(Font.custom("Ubuntu", size: 14))
                        .fontWeight(.bold)
                        .foregroundStyle(.white)
                        .minimumScaleFactor(0.2)
                        .lineLimit(1)
                }
                
                if let outcomeValue = entry.outcomeValue {
                    Text(outcomeValue)
                        .font(Font.custom("Ubuntu", size: 20))
                        .foregroundStyle(.white)
                        .minimumScaleFactor(0.2)
                }
            }
        )
        .widgetURL(URL(string: "moneye://openNewTransactionPage?homeWidget"))
    }
}

struct MonthlyOutcomeSummaryWidget: Widget {
    let kind: String = "MonthlyOutcomeSummaryWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: MonthlyOutcomeSummaryProvider()) { entry in
            if #available(iOS 17.0, *) {
                MonthlyOutcomeSummaryEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
                    .containerBackground(for: .widget) {
                        Color("WidgetBackground")
                    }
            } else {
                MonthlyOutcomeSummaryEntryView(entry: entry)
                    .padding()
                    .containerBackground(for: .widget) {
                        Color("WidgetBackground")
                    }
            }
        }
        .configurationDisplayName("This month outcome")
        .description("The fastest way to keep track of your monthly outcome")
        .supportedFamilies([.systemSmall])
    }
}


#Preview(as: .systemSmall) {
    MonthlyOutcomeSummaryWidget()
} timeline: {
    Summary(date: .now, title: "This month", outcomeValue: "-123.45€")
}
