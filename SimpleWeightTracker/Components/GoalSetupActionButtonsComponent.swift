//
//  GoalSetupActionButtonsComponent.swift
//  SimpleWeightTracker
//
//  Created by David Thorn on 16.02.2026.
//

import SwiftUI

internal struct GoalSetupActionButtonsComponent: View {
    private let canSave: Bool
    private let isPersisted: Bool
    private let hasChanges: Bool
    private let onSave: () -> Void
    private let onReset: () -> Void
    private let onDelete: () -> Void

    internal init(
        canSave: Bool,
        isPersisted: Bool,
        hasChanges: Bool,
        onSave: @escaping () -> Void,
        onReset: @escaping () -> Void,
        onDelete: @escaping () -> Void
    ) {
        self.canSave = canSave
        self.isPersisted = isPersisted
        self.hasChanges = hasChanges
        self.onSave = onSave
        self.onReset = onReset
        self.onDelete = onDelete
    }

    internal var body: some View {
        VStack(spacing: 10) {
            if canSave {
                ActionButtonComponent(
                    title: "Save Target",
                    systemImage: "checkmark.circle.fill",
                    tint: AppTheme.accent,
                    action: onSave
                )
            }

            if isPersisted && hasChanges {
                ActionButtonComponent(
                    title: "Reset",
                    systemImage: "arrow.uturn.backward.circle.fill",
                    tint: AppTheme.warning,
                    action: onReset
                )
            }

            if isPersisted {
                ActionButtonComponent(
                    title: "Delete Target",
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
        GoalSetupActionButtonsComponent(
            canSave: true,
            isPersisted: true,
            hasChanges: true,
            onSave: {},
            onReset: {},
            onDelete: {}
        )
        .padding()
        .background(AppTheme.pageGradient)
    }
#endif
