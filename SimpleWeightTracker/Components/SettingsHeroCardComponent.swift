//
//  SettingsHeroCardComponent.swift
//  SimpleWeightTracker
//
//  Created by David Thorn on 16.02.2026.
//

import SwiftUI

internal struct SettingsHeroCardComponent: View {
    internal var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: "slider.horizontal.3")
                .font(.title3.weight(.semibold))
                .foregroundStyle(AppTheme.accent)
                .frame(width: 30, height: 30)

            VStack(alignment: .leading, spacing: 6) {
                Text("Preferences & Tracking")
                    .font(.headline)
                Text("Tune your weight tracking experience with units, goals, reminders, and data controls.")
                    .font(.footnote)
                    .foregroundStyle(AppTheme.muted)
            }
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(AppTheme.cardBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .stroke(AppTheme.accent.opacity(0.2), lineWidth: 1)
                )
        )
    }
}

#if DEBUG
    #Preview {
        SettingsHeroCardComponent()
            .padding()
            .background(AppTheme.pageGradient)
    }
#endif
