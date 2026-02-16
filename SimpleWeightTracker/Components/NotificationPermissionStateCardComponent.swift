//
//  NotificationPermissionStateCardComponent.swift
//  SimpleWeightTracker
//
//  Created by David Thorn on 16.02.2026.
//

import SwiftUI

internal struct NotificationPermissionStateCardComponent: View {
    private let title: String
    private let message: String
    private let systemImage: String
    private let tint: Color
    private let actionTitle: String?
    private let actionSystemImage: String?
    private let actionTint: Color?
    private let action: () -> Void

    internal init(
        title: String,
        message: String,
        systemImage: String,
        tint: Color,
        actionTitle: String? = nil,
        actionSystemImage: String? = nil,
        actionTint: Color? = nil,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.message = message
        self.systemImage = systemImage
        self.tint = tint
        self.actionTitle = actionTitle
        self.actionSystemImage = actionSystemImage
        self.actionTint = actionTint
        self.action = action
    }

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
                    Text(message)
                        .font(.footnote)
                        .foregroundStyle(AppTheme.muted)
                }
                Spacer()
            }

            if let actionTitle, let actionSystemImage, let actionTint {
                ActionButtonComponent(
                    title: actionTitle,
                    systemImage: actionSystemImage,
                    tint: actionTint,
                    action: action
                )
            }
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
        NotificationPermissionStateCardComponent(
            title: "Permission Denied",
            message: "Notifications are currently blocked. Open Settings and enable notifications for this app.",
            systemImage: "exclamationmark.triangle.fill",
            tint: AppTheme.error,
            actionTitle: "Open Settings",
            actionSystemImage: "gearshape.fill",
            actionTint: AppTheme.error,
            action: {}
        )
        .padding()
        .background(AppTheme.pageGradient)
    }
#endif
