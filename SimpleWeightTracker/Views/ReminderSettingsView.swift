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

                    scheduleCard

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

    private var scheduleCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            SimpleToggleCardRow(
                isOn: $viewModel.isEnabled,
                title: "Enabled",
                message: "Enable scheduled reminders.",
                systemImage: "bell.badge",
                tint: AppTheme.accent
            )

            if viewModel.isEnabled {
                ReminderSettingsStepperRowComponent(
                    title: "Start Hour",
                    value: $viewModel.startHour,
                    valueTint: AppTheme.accent,
                    range: 0...23
                )

                ReminderSettingsStepperRowComponent(
                    title: "End Hour",
                    value: $viewModel.endHour,
                    valueTint: AppTheme.success,
                    range: 0...23
                )

                ReminderSettingsStepperRowComponent(
                    title: "Interval Minutes",
                    value: $viewModel.intervalMinutes,
                    valueTint: AppTheme.warning,
                    range: 30...360,
                    step: 30
                )
            } else {
                Text("Enable reminders to configure start, end, and interval.")
                    .font(.footnote)
                    .foregroundStyle(AppTheme.muted)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 10)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(inputBackground)
            }
        }
        .padding(14)
        .background(cardBackground)
    }

    private var cardBackground: some View {
        RoundedRectangle(cornerRadius: 16, style: .continuous)
            .fill(AppTheme.cardBackground)
            .overlay(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .stroke(AppTheme.border, lineWidth: 1)
            )
    }

    private var inputBackground: some View {
        RoundedRectangle(cornerRadius: 10, style: .continuous)
            .fill(Color.white.opacity(0.66))
            .overlay(
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .stroke(AppTheme.border, lineWidth: 1)
            )
    }
}

#if DEBUG
    #Preview {
        NavigationStack {
            ReminderSettingsView(serviceContainer: PreviewServiceContainer())
        }
    }
#endif
