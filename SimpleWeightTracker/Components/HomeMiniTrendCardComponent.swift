//
//  HomeMiniTrendCardComponent.swift
//  SimpleWeightTracker
//
//  Created by David Thorn on 16.02.2026.
//

import Charts
import SwiftUI

internal struct HomeMiniTrendCardComponent: View {
    internal let points: [ProgressChartPoint]
    internal let summary: ProgressSummary?
    internal let unitLabel: String

    internal var body: some View {
        let sortedPoints = points.sorted { $0.timestamp < $1.timestamp }

        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Label("7 Day Snapshot", systemImage: "waveform.path.ecg")
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.primary)
                Spacer()
                Text("\(sortedPoints.count) logs")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(AppTheme.accent)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 5)
                    .background(
                        Capsule(style: .continuous)
                            .fill(AppTheme.accent.opacity(0.13))
                    )
            }

            if let domain = sortedPoints.chartDomain() {
                Chart {
                    ForEach(sortedPoints, id: \.timestamp) { point in
                        LineMark(
                            x: .value("Time", point.timestamp),
                            y: .value("Weight", point.value)
                        )
                        .interpolationMethod(.linear)
                        .foregroundStyle(AppTheme.accent)
                        .lineStyle(StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round))
                    }
                }
                .chartXScale(domain: domain.xRange)
                .chartYScale(domain: domain.yRange)
                .chartXAxis(.hidden)
                .chartYAxis(.hidden)
                .frame(height: 88)
            } else {
                Text("Log entries to unlock your trend.")
                    .font(.footnote.weight(.semibold))
                    .foregroundStyle(AppTheme.muted)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 10)
                    .background(
                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .fill(Color.white.opacity(0.65))
                    )
            }

            if let summary {
                HStack(spacing: 8) {
                    statChip(title: "Low", value: formatted(summary.minimum), tint: AppTheme.success)
                    statChip(title: "Avg", value: formatted(summary.average), tint: AppTheme.accent)
                    statChip(title: "High", value: formatted(summary.maximum), tint: AppTheme.warning)
                }
            }
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(AppTheme.cardBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .stroke(AppTheme.accent.opacity(0.18), lineWidth: 1)
                )
        )
    }

    private func formatted(_ value: Double) -> String {
        String(format: "%.1f %@", value, unitLabel)
    }

    private func statChip(title: String, value: String, tint: Color) -> some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(title.uppercased())
                .font(.caption2.weight(.bold))
                .foregroundStyle(AppTheme.muted.opacity(0.85))
            Text(value)
                .font(.caption.weight(.semibold))
                .foregroundStyle(.primary)
                .lineLimit(1)
                .minimumScaleFactor(0.8)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 8)
        .padding(.vertical, 7)
        .background(
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .fill(tint.opacity(0.13))
                .overlay(
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .stroke(tint.opacity(0.22), lineWidth: 1)
                )
        )
    }
}

#if DEBUG
    #Preview {
        let now = Date()
        HomeMiniTrendCardComponent(
            points: [
                ProgressChartPoint(timestamp: now.addingTimeInterval(-6 * 86_400), value: 89.8),
                ProgressChartPoint(timestamp: now.addingTimeInterval(-4 * 86_400), value: 89.4),
                ProgressChartPoint(timestamp: now.addingTimeInterval(-2 * 86_400), value: 89.1),
                ProgressChartPoint(timestamp: now, value: 88.9)
            ],
            summary: ProgressSummary(netChange: -0.9, average: 89.3, minimum: 88.9, maximum: 89.8),
            unitLabel: "kg"
        )
        .padding()
        .background(AppTheme.pageGradient)
    }
#endif
