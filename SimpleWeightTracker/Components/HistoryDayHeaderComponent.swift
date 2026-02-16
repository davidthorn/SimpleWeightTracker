//
//  HistoryDayHeaderComponent.swift
//  SimpleWeightTracker
//
//  Created by David Thorn on 16.02.2026.
//

import SwiftUI

internal struct HistoryDayHeaderComponent: View {
    internal let day: Date
    internal let logCount: Int

    internal var body: some View {
        HStack(alignment: .top, spacing: 10) {
            Text(day.formatted(date: .abbreviated, time: .omitted))
                .font(.headline)
                .foregroundStyle(.primary)

            Spacer()

            Text("\(logCount) logs")
                .font(.caption.weight(.semibold))
                .foregroundStyle(AppTheme.accent)
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
                .background(
                    Capsule(style: .continuous)
                        .fill(AppTheme.accent.opacity(0.12))
                )
        }
    }
}

#if DEBUG
    #Preview {
        HistoryDayHeaderComponent(day: Date(), logCount: 2)
            .padding()
            .background(AppTheme.pageGradient)
    }
#endif
