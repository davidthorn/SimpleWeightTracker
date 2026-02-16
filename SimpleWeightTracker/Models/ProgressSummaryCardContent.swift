//
//  ProgressSummaryCardContent.swift
//  SimpleWeightTracker
//
//  Created by David Thorn on 16.02.2026.
//

import Foundation

public nonisolated struct ProgressSummaryCardContent: Sendable {
    public let windowTitle: String
    public let logCount: Int
    public let summary: ProgressSummary?
    public let points: [ProgressChartPoint]
    public let movingAveragePoints: [ProgressChartPoint]
    public let domain: ChartDomain?
    public let unitLabel: String

    public init(
        windowTitle: String,
        logCount: Int,
        summary: ProgressSummary?,
        points: [ProgressChartPoint],
        movingAveragePoints: [ProgressChartPoint],
        domain: ChartDomain?,
        unitLabel: String
    ) {
        self.windowTitle = windowTitle
        self.logCount = logCount
        self.summary = summary
        self.points = points
        self.movingAveragePoints = movingAveragePoints
        self.domain = domain
        self.unitLabel = unitLabel
    }
}
