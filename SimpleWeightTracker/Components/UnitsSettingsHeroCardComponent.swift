//
//  UnitsSettingsHeroCardComponent.swift
//  SimpleWeightTracker
//
//  Created by David Thorn on 16.02.2026.
//

import SwiftUI

internal struct UnitsSettingsHeroCardComponent: View {
    internal var body: some View {
        HStack(alignment: .top, spacing: 10) {
            Image(systemName: "scalemass")
                .font(.subheadline.weight(.bold))
                .foregroundStyle(AppTheme.accent)
                .padding(9)
                .background(
                    Circle()
                        .fill(AppTheme.accent.opacity(0.14))
                )
            VStack(alignment: .leading, spacing: 3) {
                Text("Unit Preference")
                    .font(.headline)
                Text("Pick your base measurement language.")
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
                        .stroke(AppTheme.accent.opacity(0.2), lineWidth: 1)
                )
        )
    }
}

#if DEBUG
    #Preview {
        UnitsSettingsHeroCardComponent()
            .padding()
            .background(AppTheme.pageGradient)
    }
#endif
