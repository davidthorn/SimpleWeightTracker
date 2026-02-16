//
//  HistoryFilterHeroCardComponent.swift
//  SimpleWeightTracker
//
//  Created by David Thorn on 16.02.2026.
//

import SwiftUI

internal struct HistoryFilterHeroCardComponent: View {
    internal var body: some View {
        HStack(alignment: .top, spacing: 10) {
            Image(systemName: "line.3.horizontal.decrease.circle.fill")
                .font(.subheadline.weight(.bold))
                .foregroundStyle(AppTheme.warning)
                .padding(9)
                .background(
                    Circle()
                        .fill(AppTheme.warning.opacity(0.14))
                )
            VStack(alignment: .leading, spacing: 3) {
                Text("Filter Window")
                    .font(.headline)
                Text("Focus history on the window that matters now.")
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
        HistoryFilterHeroCardComponent()
            .padding()
            .background(AppTheme.pageGradient)
    }
#endif
