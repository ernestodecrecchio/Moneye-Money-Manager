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
    let expenseValue: String?
    
    init(date: Date, title: String? = nil, incomeValue: String? = nil, expenseValue: String? = nil) {
        self.date = date
        self.title = title
        self.incomeValue = incomeValue
        self.expenseValue = expenseValue
    }
}
