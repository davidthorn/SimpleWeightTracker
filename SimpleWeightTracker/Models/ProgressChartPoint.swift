//
//  ProgressChartPoint.swift
//  SimpleWeightTracker
//
//  Created by David Thorn on 16.02.2026.
//

import Foundation

public nonisolated struct ProgressChartPoint: Identifiable, Hashable, Sendable {
    public let timestamp: Date
    public let value: Double

    public var id: TimeInterval {
        timestamp.timeIntervalSince1970
    }

    public init(timestamp: Date, value: Double) {
        self.timestamp = timestamp
        self.value = value
    }
}
