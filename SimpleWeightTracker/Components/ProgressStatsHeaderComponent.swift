//
//  ProgressStatsHeaderComponent.swift
//  SimpleWeightTracker
//
//  Created by David Thorn on 16.02.2026.
//

import SwiftUI

internal struct ProgressStatsHeaderComponent: View {
    internal let summary: ProgressSummary
    internal let unitLabel: String

    internal var body: some View {
        LazyVGrid(
            columns: [GridItem(.flexible(), spacing: 8), GridItem(.flexible(), spacing: 8)],
            spacing: 8
        ) {
            statTile(title: "Low", value: formatted(summary.minimum), tint: AppTheme.success)
            statTile(title: "Avg", value: formatted(summary.average), tint: AppTheme.accent)
            statTile(title: "High", value: formatted(summary.maximum), tint: AppTheme.warning)
            statTile(title: "Net", value: formatted(summary.netChange), tint: netTint)
        }
    }

    private var netTint: Color {
        summary.netChange >= 0 ? AppTheme.success : AppTheme.warning
    }

    private func formatted(_ value: Double) -> String {
        String(format: "%.1f %@", value, unitLabel)
    }

    private func statTile(title: String, value: String, tint: Color) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title.uppercased())
                .font(.caption2.weight(.bold))
                .foregroundStyle(AppTheme.muted)
            Text(value)
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(.primary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 10)
        .padding(.vertical, 8)
        .background(
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .fill(tint.opacity(0.13))
                .overlay(
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .stroke(tint.opacity(0.24), lineWidth: 1)
                )
        )
    }
}

#if DEBUG
    #Preview {
        ProgressStatsHeaderComponent(
            summary: ProgressSummary(netChange: -0.4, average: 89.2, minimum: 88.6, maximum: 90.1),
            unitLabel: "kg"
        )
        .padding()
        .background(AppTheme.pageGradient)
    }
#endif
