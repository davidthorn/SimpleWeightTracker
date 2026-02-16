//
//  ChartDomain.swift
//  SimpleWeightTracker
//
//  Created by David Thorn on 16.02.2026.
//

import Foundation

public nonisolated struct ChartDomain: Sendable {
    public let xMin: Date
    public let xMax: Date
    public let yMin: Double
    public let yMax: Double

    public init(xMin: Date, xMax: Date, yMin: Double, yMax: Double) {
        self.xMin = xMin
        self.xMax = xMax
        self.yMin = yMin
        self.yMax = yMax
    }

    public var xRange: ClosedRange<Date> {
        xMin...xMax
    }

    public var yRange: ClosedRange<Double> {
        yMin...yMax
    }
}
