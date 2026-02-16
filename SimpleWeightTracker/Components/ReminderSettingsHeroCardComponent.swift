//
//  ReminderSettingsHeroCardComponent.swift
//  SimpleWeightTracker
//
//  Created by David Thorn on 16.02.2026.
//

import SwiftUI

internal struct ReminderSettingsHeroCardComponent: View {
    internal var body: some View {
        HStack(alignment: .top, spacing: 10) {
            Image(systemName: "bell.badge.fill")
                .font(.subheadline.weight(.bold))
                .foregroundStyle(AppTheme.warning)
                .padding(9)
                .background(
                    Circle()
                        .fill(AppTheme.warning.opacity(0.14))
                )
            VStack(alignment: .leading, spacing: 3) {
                Text("Reminder Engine")
                    .font(.headline)
                Text("Tune cadence and active hours for your prompts.")
                    .font(.footnote)
                    .foregroundStyle(AppTheme.muted)
            }
            Spacer()
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(AppTheme.cardBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .stroke(AppTheme.warning.opacity(0.2), lineWidth: 1)
                )
        )
    }
}

#if DEBUG
    #Preview {
        ReminderSettingsHeroCardComponent()
            .padding()
            .background(AppTheme.pageGradient)
    }
#endif
