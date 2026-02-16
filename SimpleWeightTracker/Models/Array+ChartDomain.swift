//
//  Array+ChartDomain.swift
//  SimpleWeightTracker
//
//  Created by David Thorn on 16.02.2026.
//

import Foundation

public nonisolated extension Array where Element == ProgressChartPoint {
    func chartDomain(
        xPaddingRatio: Double = 0.05,
        yPaddingRatio: Double = 0.10,
        minimumYSpan: Double = 0.5
    ) -> ChartDomain? {
        guard isEmpty == false else {
            return nil
        }

        let sorted = sorted { $0.timestamp < $1.timestamp }
        guard
            let firstTimestamp = sorted.first?.timestamp,
            let lastTimestamp = sorted.last?.timestamp
        else {
            return nil
        }

        let values = sorted.map(\.value)
        guard
            let minimumValue = values.min(),
            let maximumValue = values.max()
        else {
            return nil
        }

        let xDomain: ClosedRange<Date>
        if firstTimestamp == lastTimestamp {
            let xPadding: TimeInterval = 12 * 60 * 60
            xDomain = firstTimestamp.addingTimeInterval(-xPadding)...lastTimestamp.addingTimeInterval(xPadding)
        } else {
            let xSpan = lastTimestamp.timeIntervalSince(firstTimestamp)
            let xPadding = Swift.max(xSpan * xPaddingRatio, 60.0)
            xDomain = firstTimestamp.addingTimeInterval(-xPadding)...lastTimestamp.addingTimeInterval(xPadding)
        }

        let yDomain: ClosedRange<Double>
        let ySpan = maximumValue - minimumValue
        if ySpan < 0.0001 {
            yDomain = (minimumValue - minimumYSpan)...(maximumValue + minimumYSpan)
        } else {
            let yPadding = Swift.max(ySpan * yPaddingRatio, 0.1)
            yDomain = (minimumValue - yPadding)...(maximumValue + yPadding)
        }

        return ChartDomain(
            xMin: xDomain.lowerBound,
            xMax: xDomain.upperBound,
            yMin: yDomain.lowerBound,
            yMax: yDomain.upperBound
        )
    }
}
