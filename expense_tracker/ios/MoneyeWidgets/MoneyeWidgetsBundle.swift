//
//  MoneyeWidgetsBundle.swift
//  MoneyeWidgets
//
//  Created by Ernesto De Crecchio on 09/04/24.
//

import WidgetKit
import SwiftUI

@main
struct MoneyeWidgetsBundle: WidgetBundle {
    var body: some Widget {
        MonthlySummaryWidget()
        MonthlyOutcomeSummaryWidget()
    }
}
