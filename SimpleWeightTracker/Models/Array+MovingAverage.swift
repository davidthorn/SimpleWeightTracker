//
//  Array+MovingAverage.swift
//  SimpleWeightTracker
//
//  Created by David Thorn on 16.02.2026.
//

import Foundation

public nonisolated extension Array where Element == ProgressChartPoint {
    func trailingMovingAverage(windowDays: Int = 7, minimumSampleCount: Int = 3) -> [ProgressChartPoint] {
        guard isEmpty == false else {
            return []
        }

        let sorted = sorted { $0.timestamp < $1.timestamp }
        var averagedPoints: [ProgressChartPoint] = []
        let calendar = Calendar.current

        for point in sorted {
            guard let startDate = calendar.date(byAdding: .day, value: -(windowDays - 1), to: point.timestamp) else {
                continue
            }

            let windowPoints = sorted.filter { candidate in
                candidate.timestamp >= startDate && candidate.timestamp <= point.timestamp
            }

            guard windowPoints.count >= minimumSampleCount else {
                continue
            }

            let total = windowPoints.reduce(0.0) { partialResult, candidate in
                partialResult + candidate.value
            }

            averagedPoints.append(
                ProgressChartPoint(
                    timestamp: point.timestamp,
                    value: total / Double(windowPoints.count)
                )
            )
        }

        return averagedPoints
    }
}
