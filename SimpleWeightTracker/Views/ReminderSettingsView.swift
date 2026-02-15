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
                    formHeader(
                        title: "Reminder Engine",
                        subtitle: "Tune cadence and active hours for your prompts.",
                        systemImage: "bell.badge.fill",
                        tint: AppTheme.warning
                    )

                    VStack(alignment: .leading, spacing: 12) {
                        Toggle(isOn: $viewModel.isEnabled) {
                            Text("Enabled")
                                .font(.subheadline.weight(.semibold))
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 10)
                        .background(inputBackground)

                        stepperRow(
                            title: "Start Hour",
                            valueText: "\(viewModel.startHour)",
                            tint: AppTheme.accent
                        ) {
                            Stepper(
                                "Start Hour",
                                value: $viewModel.startHour,
                                in: 0...23
                            )
                            .labelsHidden()
                        }

                        stepperRow(
                            title: "End Hour",
                            valueText: "\(viewModel.endHour)",
                            tint: AppTheme.success
                        ) {
                            Stepper(
                                "End Hour",
                                value: $viewModel.endHour,
                                in: 0...23
                            )
                            .labelsHidden()
                        }

                        stepperRow(
                            title: "Interval Minutes",
                            valueText: "\(viewModel.intervalMinutes)",
                            tint: AppTheme.warning
                        ) {
                            Stepper(
                                "Interval Minutes",
                                value: $viewModel.intervalMinutes,
                                in: 30...360,
                                step: 30
                            )
                            .labelsHidden()
                        }
                    }
                    .padding(14)
                    .background(cardBackground)

                    if let errorMessage = viewModel.errorMessage {
                        errorCard(errorMessage)
                    }

                    VStack(spacing: 10) {
                        if viewModel.hasChanges {
                            actionButton(
                                title: "Save Schedule",
                                systemImage: "checkmark.circle.fill",
                                tint: AppTheme.accent
                            ) {
                                Task {
                                    if Task.isCancelled { return }
                                    let didSave = await viewModel.save()
                                    if didSave {
                                        dismiss()
                                    }
                                }
                            }

                            if viewModel.initialSchedule != nil {
                                actionButton(
                                    title: "Reset",
                                    systemImage: "arrow.uturn.backward.circle.fill",
                                    tint: AppTheme.warning
                                ) {
                                    viewModel.reset()
                                }
                            }
                        }

                        if viewModel.initialSchedule != nil {
                            actionButton(
                                title: "Delete Schedule",
                                systemImage: "trash.fill",
                                tint: AppTheme.error
                            ) {
                                showingDeleteConfirmation = true
                            }
                        }
                    }
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

    private func formHeader(title: String, subtitle: String, systemImage: String, tint: Color) -> some View {
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
                Text(subtitle)
                    .font(.footnote)
                    .foregroundStyle(AppTheme.muted)
            }
            Spacer()
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(AppTheme.cardBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .stroke(tint.opacity(0.2), lineWidth: 1)
                )
        )
    }

    private func errorCard(_ message: String) -> some View {
        Text(message)
            .font(.footnote)
            .foregroundStyle(AppTheme.error)
            .padding(12)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(AppTheme.error.opacity(0.08))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .stroke(AppTheme.error.opacity(0.24), lineWidth: 1)
                    )
            )
    }

    private func stepperRow(title: String, valueText: String, tint: Color, content: () -> some View) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.caption.weight(.bold))
                    .foregroundStyle(AppTheme.muted)
                Text(valueText)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(tint)
            }
            Spacer()
            content()
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 10)
        .background(inputBackground)
    }

    private func actionButton(title: String, systemImage: String, tint: Color, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Label(title, systemImage: systemImage)
                .font(.subheadline.weight(.semibold))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
        }
        .buttonStyle(.plain)
        .foregroundStyle(.white)
        .background(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(tint)
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
