//
//  ProgressTrendChartComponent.swift
//  SimpleWeightTracker
//
//  Created by David Thorn on 16.02.2026.
//

import Charts
import SwiftUI

internal struct ProgressTrendChartComponent: View {
    internal let points: [ProgressChartPoint]
    internal let movingAveragePoints: [ProgressChartPoint]
    internal let domain: ChartDomain
    internal let unitLabel: String
    internal let tint: Color

    internal var body: some View {
        let sortedPoints = points.sorted { $0.timestamp < $1.timestamp }
        let sortedMovingAveragePoints = movingAveragePoints.sorted { $0.timestamp < $1.timestamp }
        let interval = DateInterval(start: domain.xMin, end: domain.xMax)
        let axisStride = interval.axisStride()

        Chart {
            ForEach(sortedPoints, id: \.timestamp) { point in
                LineMark(
                    x: .value("Time", point.timestamp),
                    y: .value("Weight", point.value),
                    series: .value("Series", "Weight")
                )
                .interpolationMethod(.linear)
                .foregroundStyle(tint)
                .lineStyle(StrokeStyle(lineWidth: 2.2, lineCap: .round, lineJoin: .round))

                if sortedPoints.count <= 3 {
                    PointMark(
                        x: .value("Time", point.timestamp),
                        y: .value("Weight", point.value)
                    )
                    .foregroundStyle(tint)
                }
            }

            ForEach(sortedMovingAveragePoints, id: \.timestamp) { point in
                LineMark(
                    x: .value("Time", point.timestamp),
                    y: .value("7-day Avg", point.value),
                    series: .value("Series", "7-day Avg")
                )
                .interpolationMethod(.linear)
                .foregroundStyle(AppTheme.warning)
                .lineStyle(StrokeStyle(lineWidth: 1.8, dash: [5, 4]))
            }
        }
        .chartXScale(domain: domain.xRange)
        .chartYScale(domain: domain.yRange)
        .chartXAxis {
            AxisMarks(values: .stride(by: axisStride.component, count: axisStride.count)) { value in
                AxisGridLine(stroke: StrokeStyle(lineWidth: 0.7))
                    .foregroundStyle(AppTheme.border)
                AxisTick(stroke: StrokeStyle(lineWidth: 0.7))
                    .foregroundStyle(AppTheme.border)
                AxisValueLabel(format: axisStride.labelFormat)
            }
        }
        .chartYAxis {
            AxisMarks(position: .leading, values: .automatic(desiredCount: 4)) { value in
                AxisGridLine(stroke: StrokeStyle(lineWidth: 0.7))
                    .foregroundStyle(AppTheme.border)
                AxisTick(stroke: StrokeStyle(lineWidth: 0.7))
                    .foregroundStyle(AppTheme.border)
                AxisValueLabel {
                    if let weightValue = value.as(Double.self) {
                        Text(String(format: "%.1f %@", weightValue, unitLabel))
                            .font(.caption2)
                            .foregroundStyle(AppTheme.muted)
                    }
                }
            }
        }
        .frame(height: 210)
    }
}

#if DEBUG
    #Preview {
        let now = Date()
        let previewPoints = [
            ProgressChartPoint(timestamp: now.addingTimeInterval(-4 * 86_400), value: 89.4),
            ProgressChartPoint(timestamp: now.addingTimeInterval(-3 * 86_400), value: 89.1),
            ProgressChartPoint(timestamp: now.addingTimeInterval(-2 * 86_400), value: 89.3),
            ProgressChartPoint(timestamp: now.addingTimeInterval(-1 * 86_400), value: 88.9),
            ProgressChartPoint(timestamp: now, value: 88.8)
        ]

        if let domain = previewPoints.chartDomain() {
            ProgressTrendChartComponent(
                points: previewPoints,
                movingAveragePoints: previewPoints.trailingMovingAverage(),
                domain: domain,
                unitLabel: "kg",
                tint: AppTheme.accent
            )
            .padding()
            .background(AppTheme.pageGradient)
        }
    }
#endif
