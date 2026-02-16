//
//  DataManagementActionCardComponent.swift
//  SimpleWeightTracker
//
//  Created by David Thorn on 16.02.2026.
//

import SwiftUI

internal struct DataManagementActionCardComponent: View {
    internal let title: String
    internal let subtitle: String
    internal let systemImage: String
    internal let tint: Color
    internal let actionTitle: String
    internal let isDisabled: Bool
    internal let action: () -> Void

    internal var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .top, spacing: 10) {
                Image(systemName: systemImage)
                    .font(.subheadline.weight(.bold))
                    .foregroundStyle(tint)
                    .padding(9)
                    .background(
                        Circle()
                            .fill(tint.opacity(0.14))
                    )

                VStack(alignment: .leading, spacing: 3) {
                    Text(title)
                        .font(.headline)
                    Text(subtitle)
                        .font(.footnote)
                        .foregroundStyle(AppTheme.muted)
                }

                Spacer()
            }

            Button(action: action) {
                Label(actionTitle, systemImage: "trash.fill")
                    .font(.subheadline.weight(.semibold))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 11)
            }
            .buttonStyle(.plain)
            .foregroundStyle(.white)
            .background(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(tint)
                    .opacity(isDisabled ? 0.45 : 1)
            )
            .disabled(isDisabled)
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(AppTheme.cardBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .stroke(tint.opacity(0.2), lineWidth: 1)
                )
        )
    }
}

#if DEBUG
    #Preview {
        DataManagementActionCardComponent(
            title: "Wipe All Data",
            subtitle: "Permanently removes all entries, goal, reminder schedule, and preferences.",
            systemImage: "trash.fill",
            tint: AppTheme.error,
            actionTitle: "Wipe All Data",
            isDisabled: false,
            action: {}
        )
        .padding()
        .background(AppTheme.pageGradient)
    }
#endif
