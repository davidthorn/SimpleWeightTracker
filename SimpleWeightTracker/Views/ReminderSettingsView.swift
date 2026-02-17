//
//  ReminderSettingsView.swift
//  SimpleWeightTracker
//
//  Created by David Thorn on 15.02.2026.
//

import SwiftUI
import SimpleFramework

internal struct ReminderSettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel: ReminderSettingsViewModel
    @State private var showingDeleteConfirmation: Bool
    @State private var isDeletingSchedule: Bool

    internal init(serviceContainer: ServiceContainerProtocol) {
        let vm = ReminderSettingsViewModel(serviceContainer: serviceContainer)
        _viewModel = StateObject(wrappedValue: vm)
        _showingDeleteConfirmation = State(initialValue: false)
        _isDeletingSchedule = State(initialValue: false)
    }

    internal var body: some View {
        ZStack {
            AppTheme.pageGradient
                .ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 14) {
                    SimpleHeroCard(
                        title: "Reminder Engine",
                        message: "Tune cadence and active hours for your prompts.",
                        systemImage: "bell.badge.fill",
                        tint: AppTheme.warning
                    )

                    SimpleReminderScheduleCard(
                        isEnabled: $viewModel.isEnabled,
                        startHour: $viewModel.startHour,
                        endHour: $viewModel.endHour,
                        intervalMinutes: $viewModel.intervalMinutes,
                        title: "Schedule",
                        enabledTitle: "Enabled",
                        enabledMessage: "Enable scheduled reminders.",
                        startHourTitle: "Start Hour",
                        endHourTitle: "End Hour",
                        intervalTitle: "Interval Minutes",
                        disabledMessage: "Enable reminders to configure start, end, and interval.",
                        tint: AppTheme.accent,
                        startValueTint: AppTheme.accent,
                        endValueTint: AppTheme.success,
                        intervalValueTint: AppTheme.warning
                    )

                    if let errorMessage = viewModel.errorMessage {
                        SimpleFormErrorCard(message: errorMessage, tint: AppTheme.error)
                    }

                    SimpleFormActionButtons(
                        showSave: viewModel.hasChanges,
                        showReset: viewModel.hasChanges && viewModel.initialSchedule != nil,
                        showDelete: viewModel.initialSchedule != nil,
                        saveTitle: "Save Schedule",
                        deleteTitle: "Delete Schedule",
                        onSave: {
                            Task {
                                if Task.isCancelled { return }
                                let didSave = await viewModel.save()
                                if didSave {
                                    dismiss()
                                }
                            }
                        },
                        onReset: {
                            viewModel.reset()
                        },
                        onDelete: {
                            showingDeleteConfirmation = true
                        }
                    )
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
            }

            if showingDeleteConfirmation {
                Color.black.opacity(0.16)
                    .ignoresSafeArea()
                    .onTapGesture {
                        if isDeletingSchedule { return }
                        showingDeleteConfirmation = false
                    }

                SimpleDestructiveConfirmationCard(
                    title: "Delete this reminder schedule?",
                    message: "This permanently removes the current reminder window and interval from this app.",
                    confirmTitle: "Delete Schedule",
                    tint: AppTheme.error,
                    isDisabled: isDeletingSchedule,
                    onCancel: {
                        showingDeleteConfirmation = false
                    },
                    onConfirm: {
                        Task {
                            if Task.isCancelled { return }
                            isDeletingSchedule = true
                            let didDelete = await viewModel.deleteSchedule()
                            isDeletingSchedule = false
                            if didDelete {
                                dismiss()
                            } else {
                                showingDeleteConfirmation = false
                            }
                        }
                    }
                )
                .padding(.horizontal, 16)
                .transition(.opacity.combined(with: .scale(scale: 0.98)))
            }
        }
        .tint(AppTheme.accent)
        .navigationTitle("Reminders")
        .task {
            if Task.isCancelled { return }
            await viewModel.load()
        }
        .animation(.easeInOut(duration: 0.2), value: showingDeleteConfirmation)
    }
}

#if DEBUG
    #Preview {
        NavigationStack {
            ReminderSettingsView(serviceContainer: PreviewServiceContainer())
        }
    }
#endif
