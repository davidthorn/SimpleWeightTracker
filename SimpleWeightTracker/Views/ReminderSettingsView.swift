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

    internal init(serviceContainer: ServiceContainerProtocol) {
        let vm = ReminderSettingsViewModel(serviceContainer: serviceContainer)
        _viewModel = StateObject(wrappedValue: vm)
        _showingDeleteConfirmation = State(initialValue: false)
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
        }
        .tint(AppTheme.accent)
        .navigationTitle("Reminders")
        .task {
            if Task.isCancelled { return }
            await viewModel.load()
        }
        .confirmationDialog("Are you sure you want to delete this?", isPresented: $showingDeleteConfirmation, titleVisibility: .visible) {
            Button("Delete", role: .destructive) {
                Task {
                    if Task.isCancelled { return }
                    let didDelete = await viewModel.deleteSchedule()
                    if didDelete {
                        dismiss()
                    }
                }
            }
            Button("Cancel", role: .cancel) {}
        }
    }
}

#if DEBUG
    #Preview {
        NavigationStack {
            ReminderSettingsView(serviceContainer: PreviewServiceContainer())
        }
    }
#endif
