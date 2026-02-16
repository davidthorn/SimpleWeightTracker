//
//  ReminderSettingsView.swift
//  SimpleWeightTracker
//
//  Created by David Thorn on 15.02.2026.
//

import SwiftUI

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
                    ReminderSettingsHeroCardComponent()

                    ReminderSettingsFormCardComponent(
                        isEnabled: $viewModel.isEnabled,
                        startHour: $viewModel.startHour,
                        endHour: $viewModel.endHour,
                        intervalMinutes: $viewModel.intervalMinutes
                    )

                    if let errorMessage = viewModel.errorMessage {
                        FormErrorCardComponent(message: errorMessage)
                    }

                    ReminderSettingsActionButtonsComponent(
                        hasChanges: viewModel.hasChanges,
                        hasPersistedSchedule: viewModel.initialSchedule != nil,
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

                DestructiveConfirmationCardComponent(
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
