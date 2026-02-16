//
//  DateInterval+AxisStride.swift
//  SimpleWeightTracker
//
//  Created by David Thorn on 16.02.2026.
//

import Foundation

public nonisolated struct DateAxisStride: Sendable {
    public let component: Calendar.Component
    public let count: Int
    public let labelFormat: Date.FormatStyle

    public init(component: Calendar.Component, count: Int, labelFormat: Date.FormatStyle) {
        self.component = component
        self.count = count
        self.labelFormat = labelFormat
    }
}

public nonisolated extension DateInterval {
    func axisStride() -> DateAxisStride {
        let days = duration / (24 * 60 * 60)

        if days <= 2 {
            return DateAxisStride(
                component: .hour,
                count: 6,
                labelFormat: .dateTime.hour(.defaultDigits(amPM: .abbreviated))
            )
        }

        if days <= 14 {
            return DateAxisStride(
                component: .day,
                count: 1,
                labelFormat: .dateTime.day().month(.abbreviated)
            )
        }

        if days <= 60 {
            return DateAxisStride(
                component: .day,
                count: 3,
                labelFormat: .dateTime.day().month(.abbreviated)
            )
        }

        if days <= 180 {
            return DateAxisStride(
                component: .weekOfYear,
                count: 1,
                labelFormat: .dateTime.day().month(.abbreviated)
            )
        }

        return DateAxisStride(
            component: .month,
            count: 1,
            labelFormat: .dateTime.month(.abbreviated)
        )
    }
}
