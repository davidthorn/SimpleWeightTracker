//
//  DayDetailTimelineCardComponent.swift
//  SimpleWeightTracker
//
//  Created by David Thorn on 15.02.2026.
//

import SwiftUI

internal struct DayDetailTimelineCardComponent: View {
    internal let entries: [WeightEntry]
    internal let targetValue: Double?
    internal let targetUnit: WeightUnit?

    internal var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Timeline")
                .font(.headline)
                .foregroundStyle(.primary)

            ForEach(Array(entries.enumerated()), id: \.element.id) { index, entry in
                DayDetailEntryRowComponent(
                    entry: entry,
                    index: index + 1,
                    targetValue: targetValue,
                    targetUnit: targetUnit
                )
            }
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(AppTheme.cardBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .stroke(AppTheme.border, lineWidth: 1)
                )
        )
    }
}

#if DEBUG
    #Preview {
        DayDetailTimelineCardComponent(
            entries: [
                WeightEntry(id: UUID(), value: 89.9, unit: .kilograms, measuredAt: Date()),
                WeightEntry(id: UUID(), value: 89.1, unit: .kilograms, measuredAt: Date().addingTimeInterval(1_800))
            ],
            targetValue: 88.7,
            targetUnit: .kilograms
        )
        .padding()
        .background(AppTheme.pageGradient)
    }
#endif
