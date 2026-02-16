//
//  FormActionButtonsComponent.swift
//  SimpleWeightTracker
//
//  Created by David Thorn on 16.02.2026.
//

import SwiftUI

internal struct FormActionButtonsComponent: View {
    private let showSave: Bool
    private let showReset: Bool
    private let showDelete: Bool
    private let saveTitle: String
    private let deleteTitle: String
    private let onSave: () -> Void
    private let onReset: () -> Void
    private let onDelete: () -> Void

    internal init(
        goalCanSave: Bool,
        isPersisted: Bool,
        hasChanges: Bool,
        onSave: @escaping () -> Void,
        onReset: @escaping () -> Void,
        onDelete: @escaping () -> Void
    ) {
        showSave = goalCanSave
        showReset = isPersisted && hasChanges
        showDelete = isPersisted
        saveTitle = "Save Target"
        deleteTitle = "Delete Target"
        self.onSave = onSave
        self.onReset = onReset
        self.onDelete = onDelete
    }

    internal init(
        reminderHasChanges: Bool,
        hasPersistedSchedule: Bool,
        onSave: @escaping () -> Void,
        onReset: @escaping () -> Void,
        onDelete: @escaping () -> Void
    ) {
        showSave = reminderHasChanges
        showReset = reminderHasChanges && hasPersistedSchedule
        showDelete = hasPersistedSchedule
        saveTitle = "Save Schedule"
        deleteTitle = "Delete Schedule"
        self.onSave = onSave
        self.onReset = onReset
        self.onDelete = onDelete
    }

    internal init(
        unitsHasChanges: Bool,
        onSave: @escaping () -> Void,
        onReset: @escaping () -> Void,
        onDelete: @escaping () -> Void
    ) {
        showSave = unitsHasChanges
        showReset = unitsHasChanges
        showDelete = true
        saveTitle = "Save Preference"
        deleteTitle = "Delete Preference"
        self.onSave = onSave
        self.onReset = onReset
        self.onDelete = onDelete
    }

    internal var body: some View {
        VStack(spacing: 10) {
            if showSave {
                ActionButtonComponent(
                    title: saveTitle,
                    systemImage: "checkmark.circle.fill",
                    tint: AppTheme.accent,
                    action: onSave
                )
            }

            if showReset {
                ActionButtonComponent(
                    title: "Reset",
                    systemImage: "arrow.uturn.backward.circle.fill",
                    tint: AppTheme.warning,
                    action: onReset
                )
            }

            if showDelete {
                ActionButtonComponent(
                    title: deleteTitle,
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
        FormActionButtonsComponent(
            goalCanSave: true,
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
