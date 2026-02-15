//
//  DayDetailEntryRowComponent.swift
//  SimpleWeightTracker
//
//  Created by David Thorn on 15.02.2026.
//

import SwiftUI

internal struct DayDetailEntryRowComponent: View {
    internal let entry: WeightEntry
    internal let index: Int
    internal let targetValue: Double?
    internal let targetUnit: WeightUnit?

    internal var body: some View {
        HStack(spacing: 10) {
            Text("\(index)")
                .font(.caption.weight(.semibold))
                .foregroundStyle(AppTheme.accent)
                .frame(width: 24, height: 24)
                .background(
                    Circle()
                        .fill(AppTheme.accent.opacity(0.14))
                )

            VStack(alignment: .leading, spacing: 4) {
                Text(String(format: "%.1f %@", entry.value, entry.unit == .kilograms ? "kg" : "lb"))
                    .font(.subheadline.weight(.semibold))

                HStack(spacing: 6) {
                    Text(entry.measuredAt.formatted(date: .omitted, time: .shortened))
                    Text(entry.measuredAt.formatted(date: .abbreviated, time: .omitted))
                }
                .font(.caption)
                .foregroundStyle(AppTheme.muted)

                trendBadge
            }

            Spacer()

            Image(systemName: trendSymbol)
                .font(.caption.weight(.bold))
                .foregroundStyle(trendTint)
                .padding(8)
                .background(
                    Circle()
                        .fill(trendTint.opacity(0.16))
                )
        }
        .padding(10)
        .background(
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .fill(Color.white.opacity(0.7))
                .overlay(
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .stroke(Color.white.opacity(0.7), lineWidth: 1)
                )
        )
    }

    private var trendBadge: some View {
        Group {
            if
                let targetValue,
                let targetUnit,
                targetUnit == entry.unit
            {
                let delta = entry.value - targetValue
                let absDelta = abs(delta)
                let unitText = entry.unit == .kilograms ? "kg" : "lb"

                if absDelta < 0.05 {
                    labelBadge(
                        text: "At target",
                        systemImage: "checkmark.seal.fill",
                        tint: AppTheme.accent
                    )
                } else if delta > 0 {
                    labelBadge(
                        text: String(format: "%.1f %@ above target", absDelta, unitText),
                        systemImage: "arrow.up.right.circle.fill",
                        tint: AppTheme.warning
                    )
                } else {
                    labelBadge(
                        text: String(format: "%.1f %@ below target", absDelta, unitText),
                        systemImage: "arrow.down.right.circle.fill",
                        tint: AppTheme.success
                    )
                }
            } else if targetValue != nil, targetUnit != nil {
                labelBadge(
                    text: "Target unit mismatch",
                    systemImage: "exclamationmark.triangle.fill",
                    tint: AppTheme.warning
                )
            } else {
                labelBadge(
                    text: "Set target for above/below feedback",
                    systemImage: "target",
                    tint: AppTheme.muted
                )
            }
        }
    }

    private var trendSymbol: String {
        guard
            let targetValue,
            let targetUnit,
            targetUnit == entry.unit
        else {
            return "target"
        }

        let delta = entry.value - targetValue
        let absDelta = abs(delta)
        if absDelta < 0.05 {
            return "equal.circle.fill"
        }
        return delta > 0 ? "arrow.up.circle.fill" : "arrow.down.circle.fill"
    }

    private var trendTint: Color {
        guard
            let targetValue,
            let targetUnit,
            targetUnit == entry.unit
        else {
            return AppTheme.muted
        }

        let delta = entry.value - targetValue
        let absDelta = abs(delta)
        if absDelta < 0.05 {
            return AppTheme.accent
        }
        return delta > 0 ? AppTheme.warning : AppTheme.success
    }

    private func labelBadge(text: String, systemImage: String, tint: Color) -> some View {
        HStack(spacing: 5) {
            Image(systemName: systemImage)
                .font(.caption2.weight(.bold))
            Text(text)
                .font(.caption2.weight(.semibold))
        }
        .foregroundStyle(tint)
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(
            Capsule(style: .continuous)
                .fill(tint.opacity(0.14))
        )
    }
}

#if DEBUG
    #Preview {
        DayDetailEntryRowComponent(
            entry: WeightEntry(
                id: UUID(),
                value: 89.2,
                unit: .kilograms,
                measuredAt: Date()
            ),
            index: 1,
            targetValue: 88.5,
            targetUnit: .kilograms
        )
        .padding()
        .background(AppTheme.pageGradient)
    }
#endif
