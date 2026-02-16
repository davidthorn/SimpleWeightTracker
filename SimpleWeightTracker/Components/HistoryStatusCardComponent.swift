//
//  HistoryStatusCardComponent.swift
//  SimpleWeightTracker
//
//  Created by David Thorn on 16.02.2026.
//

import SwiftUI

internal struct HistoryStatusCardComponent: View {
    internal let title: String
    internal let message: String
    internal let systemImage: String
    internal let tint: Color

    internal var body: some View {
        VStack(spacing: 10) {
            Image(systemName: systemImage)
                .font(.system(size: 24, weight: .semibold))
                .foregroundStyle(tint)
            Text(title)
                .font(.headline)
            Text(message)
                .font(.footnote)
                .foregroundStyle(AppTheme.muted)
                .multilineTextAlignment(.center)
        }
        .padding(20)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(AppTheme.cardBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .stroke(tint.opacity(0.18), lineWidth: 1)
                )
        )
    }
}

#if DEBUG
    #Preview {
        HistoryStatusCardComponent(
            title: "No History Yet",
            message: "Log your first weight and it will appear here.",
            systemImage: "clock.badge.questionmark",
            tint: AppTheme.accent
        )
        .padding()
        .background(AppTheme.pageGradient)
    }
#endif
