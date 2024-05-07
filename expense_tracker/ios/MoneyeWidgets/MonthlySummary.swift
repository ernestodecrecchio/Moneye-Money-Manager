//
//  MonthlySummary.swift
//  MonthlySummary
//
//  Created by Ernesto De Crecchio on 09/04/24.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> Summary {
        Summary(date: Date(), incomeValue: "1234€", outcomeValue: "-289€")
    }

    func getSnapshot(in context: Context, completion: @escaping (Summary) -> ()) {
        let entry: Summary
        
        if context.isPreview {
            entry = placeholder(in: context)
        } else {
            let userDefaults = UserDefaults(suiteName: "group.moneyewidget")
            
            
            let incomeValue = userDefaults?.string(forKey: "incomeValue") ?? "0"
            let outcomeValue = userDefaults?.string(forKey: "outcomeValue") ?? "0"
            
            entry = Summary(date: Date(), incomeValue: incomeValue, outcomeValue: outcomeValue)
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

struct Summary: TimelineEntry {
    let date: Date
    
    let incomeValue: String
    let outcomeValue: String
}

struct MonthlySummaryEntryView : View {
    var entry: Provider.Entry

    var bundle: URL {
        let bundle = Bundle.main
        if bundle.bundleURL.pathExtension == "appex" {
            var url = bundle.bundleURL.deletingLastPathComponent().deletingLastPathComponent()
            url.append(component: "Frameworks/App.framework/flutter_assets")
            return url
        }
        return bundle.bundleURL
    }
    
    init(entry: Provider.Entry) {
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
            alignment: .center, spacing: 18,
            content: {
                HStack(
                    content: {
                        Image("PocketIn")
                        Spacer()
                        Text(entry.incomeValue)
                            .font(Font.custom("Ubuntu", size: 20))
                            .foregroundStyle(.white)
                    })
                
                HStack(
                    content: {
                        Image("PocketOut")
                        Spacer()
                        Text(entry.outcomeValue)
                            .font(Font.custom("Ubuntu", size: 20))
                            .foregroundStyle(.white)
                    })
            }
        )
        .widgetURL(URL(string: "homeWidgetExample://message?message=\("TEST REDIRECT")&homeWidget"))
        .padding(.all)
    }
    
    func systemMediumWidget() -> some View {
        return VStack(
            alignment: .leading,
            spacing: 18,
            content: {
            Text("Monthly transactions")
                    .font(Font.custom("Ubuntu", size: 18))
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
            
            HStack(
                alignment: .center, spacing: 28,
                content: {
                    HStack(
                        spacing: 12,
                        content: {
                            Image("PocketIn")
                            Text(entry.incomeValue)
                                .font(Font.custom("Ubuntu", size: 20))
                                .foregroundStyle(.white)
                        })
                    
                    HStack(
                        spacing: 12,
                        content: {
                            Image("PocketOut")
                            Text(entry.outcomeValue)
                                .font(Font.custom("Ubuntu", size: 20))
                                .foregroundStyle(.white)
                        })
                }
            )
        })
        .widgetURL(URL(string: "homeWidgetExample://message?message=\("TEST REDIRECT")&homeWidget"))
        .padding(.all)
    }
}

struct MonthlySummaryWidget: Widget {
    let kind: String = "MonthlySummaryWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(iOS 17.0, *) {
                MonthlySummaryEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
                    .containerBackground(for: .widget) {
                        Color("WidgetBackground")
                    }
            } else {
                MonthlySummaryEntryView(entry: entry)
                    .padding()
                    .containerBackground(for: .widget) {
                        Color("WidgetBackground")
                    }
            }
        }
        .configurationDisplayName("Monthly summary")
        .description("The fastest way to keep track of your monthly status")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}


#Preview(as: .systemSmall) {
    MonthlySummaryWidget()
} timeline: {
    Summary(date: .now, incomeValue: "123€", outcomeValue: "-556€")
}
