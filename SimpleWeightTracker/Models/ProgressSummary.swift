//
//  ProgressSummary.swift
//  SimpleWeightTracker
//
//  Created by David Thorn on 15.02.2026.
//

import Foundation

public nonisolated struct ProgressSummary: Sendable {
    public let netChange: Double
    public let average: Double
    public let minimum: Double
    public let maximum: Double

    public init(netChange: Double, average: Double, minimum: Double, maximum: Double) {
        self.netChange = netChange
        self.average = average
        self.minimum = minimum
        self.maximum = maximum
    }
}
