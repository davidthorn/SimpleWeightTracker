//
//  HistoryDayCardComponent.swift
//  SimpleWeightTracker
//
//  Created by David Thorn on 15.02.2026.
//

import SwiftUI

internal struct HistoryDayCardComponent: View {
    internal let entries: [WeightEntry]

    internal var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            ForEach(entries) { entry in
                NavigationLink(value: HistoryRoute.entryDetail(WeightEntryIdentifier(value: entry.id))) {
                    historyEntryRow(entry)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.vertical, 2)
    }

    private func historyEntryRow(_ entry: WeightEntry) -> some View {
        HStack(spacing: 10) {
            VStack(alignment: .leading, spacing: 2) {
                Text(String(format: "%.1f %@", entry.value, entry.unit == .kilograms ? "kg" : "lb"))
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.primary)

                HStack(spacing: 6) {
                    Image(systemName: "clock.fill")
                        .font(.caption2.weight(.semibold))
                    Text(entry.measuredAt.formatted(date: .omitted, time: .shortened))
                        .font(.caption.weight(.medium))
                }
                .foregroundStyle(AppTheme.muted)
            }

            Spacer()

            Text(entry.measuredAt.formatted(date: .abbreviated, time: .omitted))
                .font(.caption2.weight(.semibold))
                .foregroundStyle(AppTheme.accent)
                .padding(.horizontal, 8)
                .padding(.vertical, 5)
                .background(
                    Capsule(style: .continuous)
                        .fill(AppTheme.accent.opacity(0.13))
                )

            Image(systemName: "chevron.right")
                .font(.caption.weight(.semibold))
                .foregroundStyle(.secondary)
                .padding(6)
                .background(
                    Circle()
                        .fill(Color.white.opacity(0.85))
                )
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 9)
        .background(
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .fill(Color.white.opacity(0.82))
                .overlay(
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .stroke(AppTheme.border, lineWidth: 1)
                )
        )
    }
}

#if DEBUG
    #Preview {
        NavigationStack {
            HistoryDayCardComponent(
                entries: [
                    WeightEntry(id: UUID(), value: 75.1, unit: .kilograms, measuredAt: Date()),
                    WeightEntry(id: UUID(), value: 74.8, unit: .kilograms, measuredAt: Date().addingTimeInterval(-3600))
                ]
            )
            .padding()
            .background(AppTheme.pageGradient)
        }
    }
#endif
