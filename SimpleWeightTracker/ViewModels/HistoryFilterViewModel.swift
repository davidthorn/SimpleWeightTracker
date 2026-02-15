//
//  HistoryFilterViewModel.swift
//  SimpleWeightTracker
//
//  Created by David Thorn on 15.02.2026.
//

import Combine
import Foundation

@MainActor
internal final class HistoryFilterViewModel: ObservableObject {
    @Published internal var selection: HistoryFilterSelection
    @Published internal var customStartDate: Date
    @Published internal var customEndDate: Date

    internal init() {
        selection = .last30Days
        let now = Date()
        customEndDate = now
        customStartDate = Calendar.current.date(byAdding: .day, value: -14, to: now) ?? now
    }

    internal var selectedRange: ClosedRange<Date> {
        let endOfToday = Calendar.current.date(bySettingHour: 23, minute: 59, second: 59, of: Date()) ?? Date()

        switch selection {
        case .last7Days:
            let start = Calendar.current.date(byAdding: .day, value: -6, to: endOfToday) ?? endOfToday
            return start...endOfToday
        case .last30Days:
            let start = Calendar.current.date(byAdding: .day, value: -29, to: endOfToday) ?? endOfToday
            return start...endOfToday
        case .custom:
            return customStartDate...customEndDate
        }
    }
}
