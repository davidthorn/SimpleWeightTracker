//
//  HistoryDayStatsComponent.swift
//  SimpleWeightTracker
//
//  Created by David Thorn on 15.02.2026.
//

import SwiftUI

internal struct HistoryDayStatsComponent: View {
    internal let group: HistoryDayGroup

    internal var body: some View {
        HStack(spacing: 8) {
            statTile(
                title: "Low",
                value: formattedValue(minimumValue),
                systemImage: "arrow.down.circle.fill",
                tint: AppTheme.success
            )
            statTile(
                title: "High",
                value: formattedValue(maximumValue),
                systemImage: "arrow.up.circle.fill",
                tint: AppTheme.warning
            )
            statTile(
                title: "Average",
                value: formattedValue(averageValue),
                systemImage: "sum",
                tint: AppTheme.accent
            )
        }
    }

    private var minimumValue: Double {
        group.entries.map(\.value).min() ?? 0
    }

    private var maximumValue: Double {
        group.entries.map(\.value).max() ?? 0
    }

    private var averageValue: Double {
        guard group.entries.isEmpty == false else {
            return 0
        }
        let total = group.entries.reduce(0.0) { partialResult, entry in
            partialResult + entry.value
        }
        return total / Double(group.entries.count)
    }

    private var unitText: String {
        let unit = group.entries.first?.unit ?? .kilograms
        return unit == .kilograms ? "kg" : "lb"
    }

    private func formattedValue(_ value: Double) -> String {
        String(format: "%.1f %@", value, unitText)
    }

    private func statTile(title: String, value: String, systemImage: String, tint: Color) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack(spacing: 4) {
                Image(systemName: systemImage)
                    .font(.caption.weight(.semibold))
                Text(title)
                    .font(.caption2.weight(.medium))
            }
            .foregroundStyle(tint)

            Text(value)
                .font(.caption.weight(.semibold))
                .foregroundStyle(.primary)
                .lineLimit(1)
                .minimumScaleFactor(0.7)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 8)
        .padding(.vertical, 8)
        .background(
            RoundedRectangle(cornerRadius: 11, style: .continuous)
                .fill(tint.opacity(0.13))
                .overlay(
                    RoundedRectangle(cornerRadius: 11, style: .continuous)
                        .stroke(tint.opacity(0.24), lineWidth: 1)
                )
        )
    }
}

#if DEBUG
    #Preview {
        HistoryDayStatsComponent(
            group: HistoryDayGroup(
                day: Date(),
                entries: [
                    WeightEntry(id: UUID(), value: 75.4, unit: .kilograms, measuredAt: Date()),
                    WeightEntry(id: UUID(), value: 74.9, unit: .kilograms, measuredAt: Date().addingTimeInterval(-7200)),
                    WeightEntry(id: UUID(), value: 75.1, unit: .kilograms, measuredAt: Date().addingTimeInterval(-14400))
                ]
            )
        )
        .padding()
        .background(AppTheme.pageGradient)
    }
#endif
