//
//  WeightProgressSummaryCardComponent.swift
//  SimpleWeightTracker
//
//  Created by David Thorn on 16.02.2026.
//

import SwiftUI

internal struct WeightProgressSummaryCardComponent: View {
    private let content: ProgressSummaryCardContent
    private let tint: Color

    internal init(content: ProgressSummaryCardContent, tint: Color) {
        self.content = content
        self.tint = tint
    }

    internal var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Label(content.windowTitle, systemImage: "waveform.path.ecg")
                    .font(.headline)
                    .foregroundStyle(.primary)
                Spacer()
                Text("\(content.logCount) logs")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(tint)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(
                        Capsule(style: .continuous)
                            .fill(tint.opacity(0.14))
                    )
            }

            if let summary = content.summary {
                ProgressStatsHeaderComponent(summary: summary, unitLabel: content.unitLabel)
            } else {
                Text("Not enough data")
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

            if let domain = content.domain {
                ProgressTrendChartComponent(
                    points: content.points,
                    movingAveragePoints: content.movingAveragePoints,
                    domain: domain,
                    unitLabel: content.unitLabel,
                    tint: tint
                )
                ProgressRangeLegendComponent(tint: tint)
            }
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(AppTheme.cardBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .stroke(tint.opacity(0.2), lineWidth: 1)
                )
        )
    }
}

#if DEBUG
    #Preview {
        WeightProgressSummaryCardComponent(
            content: ProgressSummaryCardContent(
                windowTitle: "7 Day Trend",
                logCount: 8,
                summary: nil,
                points: [],
                movingAveragePoints: [],
                domain: nil,
                unitLabel: "kg"
            ),
            tint: AppTheme.success
        )
        .padding()
        .background(AppTheme.pageGradient)
    }
#endif
