//
//  UnitsSettingsActionButtonsComponent.swift
//  SimpleWeightTracker
//
//  Created by David Thorn on 16.02.2026.
//

import SwiftUI

internal struct UnitsSettingsActionButtonsComponent: View {
    private let hasChanges: Bool
    private let onSave: () -> Void
    private let onReset: () -> Void
    private let onDelete: () -> Void

    internal init(
        hasChanges: Bool,
        onSave: @escaping () -> Void,
        onReset: @escaping () -> Void,
        onDelete: @escaping () -> Void
    ) {
        self.hasChanges = hasChanges
        self.onSave = onSave
        self.onReset = onReset
        self.onDelete = onDelete
    }

    internal var body: some View {
        VStack(spacing: 10) {
            if hasChanges {
                ActionButtonComponent(
                    title: "Save Preference",
                    systemImage: "checkmark.circle.fill",
                    tint: AppTheme.accent,
                    action: onSave
                )

                ActionButtonComponent(
                    title: "Reset",
                    systemImage: "arrow.uturn.backward.circle.fill",
                    tint: AppTheme.warning,
                    action: onReset
                )
            }

            ActionButtonComponent(
                title: "Delete Preference",
                systemImage: "trash.fill",
                tint: AppTheme.error,
                action: onDelete
            )
        }
    }
}

#if DEBUG
    #Preview {
        UnitsSettingsActionButtonsComponent(
            hasChanges: true,
            onSave: {},
            onReset: {},
            onDelete: {}
        )
        .padding()
        .background(AppTheme.pageGradient)
    }
#endif
