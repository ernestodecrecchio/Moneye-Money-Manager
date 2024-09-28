//
//  MonthlyExpensesSummary.swift
//  Runner
//
//  Created by Ernesto De Crecchio on 11/06/24.
//

import WidgetKit
import SwiftUI

struct MonthlyExpensesSummaryProvider: TimelineProvider {
    func placeholder(in context: Context) -> Summary {
        Summary(date: Date(),
                expenseValue: NSLocalizedString("ExpenseValuePlaceholder", comment: ""))
    }

    func getSnapshot(in context: Context, completion: @escaping (Summary) -> ()) {
        let entry: Summary
        
        if context.isPreview {
            entry = placeholder(in: context)
        } else {
            let userDefaults = UserDefaults(suiteName: "group.moneyewidget")
            let expenseValue = userDefaults?.string(forKey: "expenseValue") ?? "0€"
            
            entry = Summary(date: Date(), expenseValue: expenseValue)
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

struct MonthlyExpensesSummaryEntryView : View {
    var entry: MonthlyExpensesSummaryProvider.Entry

    var bundle: URL {
        let bundle = Bundle.main
        if bundle.bundleURL.pathExtension == "appex" {
            var url = bundle.bundleURL.deletingLastPathComponent().deletingLastPathComponent()
            url.append(component: "Frameworks/App.framework/flutter_assets")
            return url
        }
        return bundle.bundleURL
    }
    
    init(entry: MonthlyExpensesSummaryProvider.Entry) {
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
                    Text(NSLocalizedString("ThisMonth", comment: ""))
                        .font(Font.custom("Ubuntu", size: 18))
                        .fontWeight(.bold)
                        .foregroundStyle(.white)
                        .minimumScaleFactor(0.2)
                        .lineLimit(1)
                
                
                if let expenseValue = entry.expenseValue {
                    Text(expenseValue)
                        .font(Font.custom("Ubuntu", size: 20))
                        .foregroundStyle(.white)
                        .minimumScaleFactor(0.2)
                }
            }
        )
        .widgetURL(URL(string: "moneye://openNewTransactionPage?homeWidget"))
    }
}

struct MonthlyExpensesSummaryWidget: Widget {
    let kind: String = "MonthlyExpensesSummaryWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: MonthlyExpensesSummaryProvider()) { entry in
            if #available(iOS 17.0, *) {
                MonthlyExpensesSummaryEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
                    .containerBackground(for: .widget) {
                        Color(.widgetBackground)
                    }
            } else {
                MonthlyExpensesSummaryEntryView(entry: entry)
                    .padding()
                    .containerBackground(for: .widget) {
                        Color(.widgetBackground)
                    }
            }
        }
        .configurationDisplayName(NSLocalizedString("MonthlyExpensesSummaryWidgetTitle", comment: ""))
        .description(NSLocalizedString("MonthlyExpensesSummaryWidgetDescription", comment: ""))
        .supportedFamilies([.systemSmall])
    }
}


#Preview(as: .systemSmall) {
    MonthlyExpensesSummaryWidget()
} timeline: {
    Summary(date: .now, expenseValue: NSLocalizedString("ExpenseValuePlaceholder", comment: ""))
}
