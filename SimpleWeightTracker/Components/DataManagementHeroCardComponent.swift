//
//  DataManagementHeroCardComponent.swift
//  SimpleWeightTracker
//
//  Created by David Thorn on 16.02.2026.
//

import SwiftUI

internal struct DataManagementHeroCardComponent: View {
    internal var body: some View {
        HStack(alignment: .top, spacing: 10) {
            Image(systemName: "externaldrive.badge.exclamationmark")
                .font(.subheadline.weight(.bold))
                .foregroundStyle(AppTheme.error)
                .padding(9)
                .background(
                    Circle()
                        .fill(AppTheme.error.opacity(0.14))
                )

            VStack(alignment: .leading, spacing: 3) {
                Text("Data Controls")
                    .font(.headline)
                Text("Use these actions carefully. Some operations permanently remove stored data.")
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
                        .stroke(AppTheme.error.opacity(0.2), lineWidth: 1)
                )
        )
    }
}

#if DEBUG
    #Preview {
        DataManagementHeroCardComponent()
            .padding()
            .background(AppTheme.pageGradient)
    }
#endif
