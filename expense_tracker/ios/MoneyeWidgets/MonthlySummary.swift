//
//  MonthlySummary.swift
//  MonthlySummary
//
//  Created by Ernesto De Crecchio on 09/04/24.
//

import WidgetKit
import SwiftUI

struct MonthlhySummaryProvider: TimelineProvider {
    func placeholder(in context: Context) -> Summary {
        Summary(date: Date(),
                incomeValue: NSLocalizedString("IncomeValuePlaceholder", comment: ""),
                expenseValue: NSLocalizedString("ExpenseValuePlaceholder", comment: ""))
    }

    func getSnapshot(in context: Context, completion: @escaping (Summary) -> ()) {
        let entry: Summary
        
        if context.isPreview {
            entry = placeholder(in: context)
        } else {
            let userDefaults = UserDefaults(suiteName: "group.moneyewidget")
            
            let incomeValue = userDefaults?.string(forKey: "incomeValue") ?? "0€"
            let expenseValue = userDefaults?.string(forKey: "expenseValue") ?? "0€"
            
            entry = Summary(date: Date(), 
                            incomeValue: incomeValue,
                            expenseValue: expenseValue)
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


struct MonthlySummaryEntryView : View {
    var entry: MonthlhySummaryProvider.Entry

    var bundle: URL {
        let bundle = Bundle.main
        if bundle.bundleURL.pathExtension == "appex" {
            var url = bundle.bundleURL.deletingLastPathComponent().deletingLastPathComponent()
            url.append(component: "Frameworks/App.framework/flutter_assets")
            return url
        }
        return bundle.bundleURL
    }
    
    init(entry: MonthlhySummaryProvider.Entry) {
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
            case .systemMedium:
                systemMediumWidget()
            default:
                systemSmallWidget()
            }
        }
    
    func systemSmallWidget() -> some View {
        return VStack(
            alignment: .leading, spacing: 18,
            content: {
               
                Text(NSLocalizedString("ThisMonth", comment: ""))
                        .font(Font.custom("Ubuntu", size: 18))
                        .fontWeight(.bold)
                        .foregroundStyle(.white)
                        .minimumScaleFactor(0.2)
                        .lineLimit(1)
                
                
                if let incomeValue = entry.incomeValue {
                    HStack(
                        content: {
                            Image("PocketIn")
                            Spacer()
                            Text(incomeValue)
                                .font(Font.custom("Ubuntu", size: 20))
                                .foregroundStyle(.white)
                                .minimumScaleFactor(0.2)
                        })
                }
                
                if let expenseValue = entry.expenseValue {
                    HStack(
                        content: {
                            Image("PocketOut")
                            Spacer()
                            Text(expenseValue)
                                .font(Font.custom("Ubuntu", size: 20))
                                .foregroundStyle(.white)
                                .minimumScaleFactor(0.2)
                        })
                }
            }
        )
        .widgetURL(URL(string: "moneye://openNewTransactionPage?homeWidget"))
    }
    
    func systemMediumWidget() -> some View {
        return VStack(
            alignment: .leading,
            spacing: 24,
            content: {
                    Text(NSLocalizedString("ThisMonth", comment: ""))
                        .font(Font.custom("Ubuntu", size: 18))
                        .fontWeight(.bold)
                        .foregroundStyle(.white)
                        .minimumScaleFactor(0.2)
                        .lineLimit(1)
                        .frame(maxWidth: .infinity, alignment: .leading)
                
                
                HStack(
                    alignment: .center, spacing: 28,
                    content: {
                        if let incomeValue = entry.incomeValue {
                            HStack(
                                spacing: 12,
                                content: {
                                    Image("PocketIn")
                                    Text(incomeValue)
                                        .font(Font.custom("Ubuntu", size: 20))
                                        .foregroundStyle(.white)
                                        .minimumScaleFactor(0.2)
                                        
                                })
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        
                        if let expenseValue = entry.expenseValue {
                            HStack(
                                spacing: 12,
                                content: {
                                    Image("PocketOut")
                                    Text(expenseValue)
                                        .font(Font.custom("Ubuntu", size: 20))
                                        .foregroundStyle(.white)
                                        .minimumScaleFactor(0.2)
                                      
                                })
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                )
            })
            .widgetURL(URL(string: "moneye://openNewTransactionPage?homeWidget"))
            .padding(.all)
    }
}

struct MonthlySummaryWidget: Widget {
    let kind: String = "MonthlySummaryWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: MonthlhySummaryProvider()) { entry in
            if #available(iOS 17.0, *) {
                MonthlySummaryEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
                    .containerBackground(for: .widget) {
                        Color(.widgetBackground)
                    }
            } else {
                MonthlySummaryEntryView(entry: entry)
                    .padding()
                    .containerBackground(for: .widget) {
                        Color(.widgetBackground)
                    }
            }
        }
        .configurationDisplayName(NSLocalizedString("MonthlySummaryWidgetTitle", comment: ""))
        .description(NSLocalizedString("MonthlySummaryWidgetDescription", comment: ""))
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}


#Preview(as: .systemMedium) {
    MonthlySummaryWidget()
} timeline: {
    Summary(date: .now, 
            incomeValue: NSLocalizedString("IncomeValuePlaceholder", comment: ""),
            expenseValue: NSLocalizedString("ExpenseValuePlaceholder", comment: ""))
}
