//
//  HistoryFilterConfiguration.swift
//  SimpleWeightTracker
//
//  Created by David Thorn on 16.02.2026.
//

import Foundation

public nonisolated struct HistoryFilterConfiguration: Codable, Hashable, Sendable {
    public let selection: HistoryFilterSelection
    public let customStartDate: Date
    public let customEndDate: Date

    public init(selection: HistoryFilterSelection, customStartDate: Date, customEndDate: Date) {
        self.selection = selection
        self.customStartDate = customStartDate
        self.customEndDate = customEndDate
    }

    public func resolvedRange(referenceDate: Date = Date(), calendar: Calendar = .current) -> ClosedRange<Date> {
        let endOfToday = calendar.date(bySettingHour: 23, minute: 59, second: 59, of: referenceDate) ?? referenceDate

        switch selection {
        case .last7Days:
            let start = calendar.date(byAdding: .day, value: -6, to: endOfToday) ?? endOfToday
            return start...endOfToday
        case .last30Days:
            let start = calendar.date(byAdding: .day, value: -29, to: endOfToday) ?? endOfToday
            return start...endOfToday
        case .custom:
            let normalizedStart = calendar.startOfDay(for: min(customStartDate, customEndDate))
            let normalizedEndDate = max(customStartDate, customEndDate)
            let normalizedEnd = calendar.date(
                bySettingHour: 23,
                minute: 59,
                second: 59,
                of: normalizedEndDate
            ) ?? normalizedEndDate
            return normalizedStart...normalizedEnd
        }
    }

    public static func defaultValue(referenceDate: Date = Date(), calendar: Calendar = .current) -> HistoryFilterConfiguration {
        let customEndDate = referenceDate
        let customStartDate = calendar.date(byAdding: .day, value: -14, to: referenceDate) ?? referenceDate
        return HistoryFilterConfiguration(
            selection: .last30Days,
            customStartDate: customStartDate,
            customEndDate: customEndDate
        )
    }
}
