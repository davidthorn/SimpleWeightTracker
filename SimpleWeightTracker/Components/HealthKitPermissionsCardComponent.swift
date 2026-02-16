//
//  HealthKitPermissionsCardComponent.swift
//  SimpleWeightTracker
//
//  Created by David Thorn on 16.02.2026.
//

import SwiftUI

internal struct HealthKitPermissionsCardComponent: View {
    private let permissionState: HealthKitWeightPermissionState
    private let statusSummaryText: String
    private let isHealthKitAvailable: Bool
    private let onRequestAccess: () -> Void
    private let onOpenSettings: () -> Void

    internal init(
        permissionState: HealthKitWeightPermissionState,
        statusSummaryText: String,
        isHealthKitAvailable: Bool,
        onRequestAccess: @escaping () -> Void,
        onOpenSettings: @escaping () -> Void
    ) {
        self.permissionState = permissionState
        self.statusSummaryText = statusSummaryText
        self.isHealthKitAvailable = isHealthKitAvailable
        self.onRequestAccess = onRequestAccess
        self.onOpenSettings = onOpenSettings
    }

    internal var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Weight Permissions")
                .font(.subheadline.weight(.semibold))

            HStack(spacing: 10) {
                HealthKitPermissionStatePillComponent(
                    title: "Read",
                    state: permissionState.read
                )
                HealthKitPermissionStatePillComponent(
                    title: "Write",
                    state: permissionState.write
                )
            }

            Text(statusSummaryText)
                .font(.footnote)
                .foregroundStyle(AppTheme.muted)

            if isHealthKitAvailable {
                HStack(spacing: 10) {
                    ActionButtonComponent(
                        title: "Request Access",
                        systemImage: "heart.fill",
                        tint: AppTheme.accent,
                        font: .footnote.weight(.semibold),
                        verticalPadding: 10,
                        cornerRadius: 10,
                        action: onRequestAccess
                    )

                    if permissionState.read == .denied || permissionState.write == .denied {
                        ActionButtonComponent(
                            title: "Open Settings",
                            systemImage: "gearshape.fill",
                            tint: AppTheme.warning,
                            font: .footnote.weight(.semibold),
                            verticalPadding: 10,
                            cornerRadius: 10,
                            action: onOpenSettings
                        )
                    }
                }
            }
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(AppTheme.cardBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .stroke(AppTheme.border, lineWidth: 1)
                )
        )
    }

}

#if DEBUG
    #Preview {
        HealthKitPermissionsCardComponent(
            permissionState: HealthKitWeightPermissionState(read: .authorized, write: .denied),
            statusSummaryText: "At least one permission is denied. Open Settings to update access.",
            isHealthKitAvailable: true,
            onRequestAccess: {},
            onOpenSettings: {}
        )
        .padding()
        .background(AppTheme.pageGradient)
    }
#endif
