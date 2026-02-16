//
//  HomeMiniTrendCardViewModel.swift
//  SimpleWeightTracker
//
//  Created by David Thorn on 16.02.2026.
//

import Combine
import Foundation

@MainActor
internal final class HomeMiniTrendCardViewModel: ObservableObject {
    internal init() {}

    internal func unitLabel(for preferredUnit: WeightUnit) -> String {
        preferredUnit.shortLabel
    }

    internal func sevenDayChartPoints(from entries: [WeightEntry], preferredUnit: WeightUnit) -> [ProgressChartPoint] {
        let cutoffDate = Calendar.current.date(byAdding: .day, value: -6, to: Date()) ?? Date()
        let filtered = entries.filter { $0.measuredAt >= cutoffDate }
        let calendar = Calendar.current
        let groupedByDay = Dictionary(grouping: filtered) { entry in
            calendar.startOfDay(for: entry.measuredAt)
        }

        return groupedByDay
            .map { day, dayEntries in
                let total = dayEntries.reduce(0.0) { partialResult, entry in
                    partialResult + preferredUnit.convertedValue(entry.value, from: entry.unit)
                }
                let average = total / Double(dayEntries.count)

                return ProgressChartPoint(timestamp: day, value: average)
            }
            .sorted { $0.timestamp < $1.timestamp }
    }

    internal func summary(from points: [ProgressChartPoint]) -> ProgressSummary? {
        guard points.isEmpty == false else {
            return nil
        }

        let values = points.map(\.value)
        guard
            let minimum = values.min(),
            let maximum = values.max(),
            let first = points.first,
            let last = points.last
        else {
            return nil
        }

        let total = values.reduce(0.0, +)
        let average = total / Double(values.count)

        return ProgressSummary(
            netChange: last.value - first.value,
            average: average,
            minimum: minimum,
            maximum: maximum
        )
    }
}
