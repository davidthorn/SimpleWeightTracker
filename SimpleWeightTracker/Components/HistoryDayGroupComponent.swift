//
//  HistoryDayGroupComponent.swift
//  SimpleWeightTracker
//
//  Created by David Thorn on 16.02.2026.
//

import SwiftUI

internal struct HistoryDayGroupComponent: View {
    internal let group: HistoryDayGroup

    internal var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            NavigationLink(value: HistoryRoute.dayDetail(WeightDayIdentifier(value: group.day))) {
                HistoryDayHeaderComponent(day: group.day, logCount: group.entries.count)
            }
            .buttonStyle(.plain)

            HistoryDayStatsComponent(group: group)
            HistoryDayCardComponent(entries: group.entries)
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(Color.white.opacity(0.56))
                .overlay(
                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                        .stroke(Color.white.opacity(0.8), lineWidth: 1)
                )
        )
        .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 4)
    }
}

#if DEBUG
    #Preview {
        let now = Date()
        let entries: [WeightEntry] = [
            WeightEntry(id: UUID(), value: 88.7, unit: .kilograms, measuredAt: now),
            WeightEntry(id: UUID(), value: 88.4, unit: .kilograms, measuredAt: now.addingTimeInterval(-43_200))
        ]

        let group = HistoryDayGroup(day: now, entries: entries)

        NavigationStack {
            HistoryDayGroupComponent(group: group)
                .padding()
                .background(AppTheme.pageGradient)
        }
    }
#endif
