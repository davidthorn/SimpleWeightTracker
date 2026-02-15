//
//  HomeHeroCardComponent.swift
//  SimpleWeightTracker
//
//  Created by David Thorn on 15.02.2026.
//

import SwiftUI

internal struct HomeHeroCardComponent: View {
    internal let latestValueText: String?
    internal let latestUnitText: String?
    internal let goalStatusText: String
    internal let todayLogCount: Int
    internal let lastLoggedText: String

    internal var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 8) {
                Image(systemName: "scalemass.fill")
                    .font(.subheadline.weight(.bold))
                    .foregroundStyle(AppTheme.accent)
                    .padding(8)
                    .background(
                        Circle()
                            .fill(AppTheme.accent.opacity(0.14))
                    )
                Text("Today's Weight Pulse")
                    .font(.headline.weight(.semibold))
                    .foregroundStyle(.primary)
                Spacer()
            }

            if let latestValueText, let latestUnitText {
                HStack(alignment: .firstTextBaseline, spacing: 6) {
                    Text(latestValueText)
                        .font(.system(size: 40, weight: .bold, design: .rounded))
                        .foregroundStyle(.primary)
                    Text(latestUnitText)
                        .font(.title3.weight(.bold))
                        .foregroundStyle(AppTheme.accent)
                }
            } else {
                Text("No entry yet")
                    .font(.system(size: 34, weight: .bold, design: .rounded))
                    .foregroundStyle(AppTheme.muted)
            }

            Text(goalStatusText)
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(AppTheme.muted)
                .padding(.bottom, 2)

            HStack(spacing: 8) {
                heroStatChip(
                    title: "Logs",
                    value: "\(todayLogCount)",
                    systemImage: "list.bullet.clipboard",
                    tint: AppTheme.success
                )
                heroStatChip(
                    title: "Last",
                    value: lastLoggedText,
                    systemImage: "clock.fill",
                    tint: AppTheme.warning
                )
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(AppTheme.cardBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .stroke(AppTheme.accent.opacity(0.22), lineWidth: 1)
                )
        )
        .shadow(color: AppTheme.accent.opacity(0.08), radius: 12, x: 0, y: 5)
    }

    private func heroStatChip(title: String, value: String, systemImage: String, tint: Color) -> some View {
        HStack(spacing: 8) {
            Image(systemName: systemImage)
                .font(.caption.weight(.bold))
                .foregroundStyle(tint)
            VStack(alignment: .leading, spacing: 1) {
                Text(title.uppercased())
                    .font(.caption2.weight(.bold))
                    .foregroundStyle(AppTheme.muted.opacity(0.8))
                Text(value)
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.primary)
                    .lineLimit(1)
            }
            Spacer(minLength: 0)
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 10)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .fill(tint.opacity(0.13))
        )
    }
}

#if DEBUG
    #Preview {
        HomeHeroCardComponent(
            latestValueText: "74.3",
            latestUnitText: "kg",
            goalStatusText: "0.7 kg to target",
            todayLogCount: 3,
            lastLoggedText: "6:42 PM"
        )
        .padding()
        .background(AppTheme.pageGradient)
    }
#endif
