//
//  ReminderSettingsActionButtonsComponent.swift
//  SimpleWeightTracker
//
//  Created by David Thorn on 16.02.2026.
//

import SwiftUI

internal struct ReminderSettingsActionButtonsComponent: View {
    private let hasChanges: Bool
    private let hasPersistedSchedule: Bool
    private let onSave: () -> Void
    private let onReset: () -> Void
    private let onDelete: () -> Void

    internal init(
        hasChanges: Bool,
        hasPersistedSchedule: Bool,
        onSave: @escaping () -> Void,
        onReset: @escaping () -> Void,
        onDelete: @escaping () -> Void
    ) {
        self.hasChanges = hasChanges
        self.hasPersistedSchedule = hasPersistedSchedule
        self.onSave = onSave
        self.onReset = onReset
        self.onDelete = onDelete
    }

    internal var body: some View {
        VStack(spacing: 10) {
            if hasChanges {
                ActionButtonComponent(
                    title: "Save Schedule",
                    systemImage: "checkmark.circle.fill",
                    tint: AppTheme.accent,
                    action: onSave
                )

                if hasPersistedSchedule {
                    ActionButtonComponent(
                        title: "Reset",
                        systemImage: "arrow.uturn.backward.circle.fill",
                        tint: AppTheme.warning,
                        action: onReset
                    )
                }
            }

            if hasPersistedSchedule {
                ActionButtonComponent(
                    title: "Delete Schedule",
                    systemImage: "trash.fill",
                    tint: AppTheme.error,
                    action: onDelete
                )
            }
        }
    }
}

#if DEBUG
    #Preview {
        ReminderSettingsActionButtonsComponent(
            hasChanges: true,
            hasPersistedSchedule: true,
            onSave: {},
            onReset: {},
            onDelete: {}
        )
        .padding()
        .background(AppTheme.pageGradient)
    }
#endif
