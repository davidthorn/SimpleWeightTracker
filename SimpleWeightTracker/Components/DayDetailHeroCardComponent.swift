//
//  DayDetailHeroCardComponent.swift
//  SimpleWeightTracker
//
//  Created by David Thorn on 15.02.2026.
//

import SwiftUI

internal struct DayDetailHeroCardComponent: View {
    internal let title: String
    internal let subtitle: String
    internal let entryCount: Int
    internal let goalFeedbackText: String
    internal let firstEntryTimeText: String
    internal let lastEntryTimeText: String
    internal let minimumValueText: String
    internal let averageValueText: String
    internal let maximumValueText: String

    internal var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .top, spacing: 12) {
                Image(systemName: "sparkles.rectangle.stack.fill")
                    .font(.title3.weight(.semibold))
                    .foregroundStyle(.white)
                    .frame(width: 32, height: 32)
                    .background(
                        Circle()
                            .fill(Color.white.opacity(0.22))
                    )

                VStack(alignment: .leading, spacing: 3) {
                    Text(title)
                        .font(.headline.weight(.semibold))
                        .foregroundStyle(.white)
                    Text(subtitle)
                        .font(.footnote)
                        .foregroundStyle(Color.white.opacity(0.85))
                }

                Spacer()

                Text("\(entryCount) logs")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.white)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(
                        Capsule(style: .continuous)
                            .fill(Color.white.opacity(0.2))
                    )
            }

            Text(goalFeedbackText)
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(.white)
                .padding(.horizontal, 10)
                .padding(.vertical, 8)
                .background(
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .fill(Color.white.opacity(0.18))
                )

            HStack(spacing: 8) {
                DayDetailStatPillComponent(
                    title: "First",
                    value: firstEntryTimeText,
                    symbol: "sunrise.fill",
                    tint: AppTheme.accent
                )
                DayDetailStatPillComponent(
                    title: "Last",
                    value: lastEntryTimeText,
                    symbol: "moon.stars.fill",
                    tint: AppTheme.warning
                )
            }

            HStack(spacing: 8) {
                DayDetailStatPillComponent(
                    title: "Low",
                    value: minimumValueText,
                    symbol: "arrow.down.to.line",
                    tint: AppTheme.success
                )
                DayDetailStatPillComponent(
                    title: "Avg",
                    value: averageValueText,
                    symbol: "sum",
                    tint: AppTheme.accent
                )
                DayDetailStatPillComponent(
                    title: "High",
                    value: maximumValueText,
                    symbol: "arrow.up.to.line",
                    tint: AppTheme.warning
                )
            }
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [
                            AppTheme.accent.opacity(0.58),
                            Color(red: 0.70, green: 0.86, blue: 0.93)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .stroke(Color.white.opacity(0.3), lineWidth: 1)
                )
        )
        .shadow(color: AppTheme.accent.opacity(0.08), radius: 8, x: 0, y: 3)
    }
}

#if DEBUG
    #Preview {
        DayDetailHeroCardComponent(
            title: "Day Summary",
            subtitle: "Sunday, 15 Feb 2026",
            entryCount: 5,
            goalFeedbackText: "1.2 kg below target",
            firstEntryTimeText: "7:20 AM",
            lastEntryTimeText: "8:10 PM",
            minimumValueText: "88.8 kg",
            averageValueText: "89.4 kg",
            maximumValueText: "90.0 kg"
        )
        .padding()
        .background(AppTheme.pageGradient)
    }
#endif
