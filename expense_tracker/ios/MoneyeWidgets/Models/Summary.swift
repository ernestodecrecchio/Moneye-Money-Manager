//
//  Summary.swift
//  Runner
//
//  Created by Ernesto De Crecchio on 11/06/24.
//

import WidgetKit

struct Summary: TimelineEntry {
    let date: Date
    
    let title: String?
    let incomeValue: String?
    let outcomeValue: String?
    
    init(date: Date, title: String?, incomeValue: String? = nil, outcomeValue: String? = nil) {
        self.date = date
        self.title = title
        self.incomeValue = incomeValue
        self.outcomeValue = outcomeValue
    }
}
