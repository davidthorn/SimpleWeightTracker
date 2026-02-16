//
//  DataManagementView.swift
//  SimpleWeightTracker
//
//  Created by David Thorn on 15.02.2026.
//

import SwiftUI

internal struct DataManagementView: View {
    @StateObject private var viewModel: DataManagementViewModel
    @State private var pendingConfirmationAction: DataManagementConfirmationAction?

    internal init(serviceContainer: ServiceContainerProtocol) {
        let vm = DataManagementViewModel(serviceContainer: serviceContainer)
        _viewModel = StateObject(wrappedValue: vm)
        _pendingConfirmationAction = State(initialValue: nil)
    }

    internal var body: some View {
        ZStack {
            AppTheme.pageGradient
                .ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 14) {
                    DataManagementHeroCardComponent()

                    sectionTitle("Targeted Actions")

                    DataManagementActionCardComponent(
                        title: "Delete Goal",
                        subtitle: "Removes your current target while keeping historical entries.",
                        systemImage: "target",
                        tint: AppTheme.warning,
                        actionTitle: "Delete Goal",
                        isDisabled: viewModel.isPerformingAction
                    ) {
                        pendingConfirmationAction = .clearGoal
                    }

                    DataManagementActionCardComponent(
                        title: "Reset Preferences",
                        subtitle: "Resets units, reminder schedule, history filter, and HealthKit sync settings.",
                        systemImage: "slider.horizontal.3",
                        tint: AppTheme.accent,
                        actionTitle: "Reset Preferences",
                        isDisabled: viewModel.isPerformingAction
                    ) {
                        pendingConfirmationAction = .resetPreferences
                    }

                    sectionTitle("Danger Zone")

                    DataManagementActionCardComponent(
                        title: "Wipe All Data",
                        subtitle: "Permanently removes all entries, goal, reminder schedule, and preferences including HealthKit sync.",
                        systemImage: "trash.fill",
                        tint: AppTheme.error,
                        actionTitle: "Wipe All Data",
                        isDisabled: viewModel.isPerformingAction
                    ) {
                        pendingConfirmationAction = .wipeAllData
                    }

                    if let message = viewModel.message {
                        DataManagementFeedbackCardComponent(
                            message: message,
                            isError: viewModel.isErrorMessage
                        )
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
            }

            if let pendingConfirmationAction {
                Color.black.opacity(0.16)
                    .ignoresSafeArea()
                    .onTapGesture {
                        if viewModel.isPerformingAction { return }
                        self.pendingConfirmationAction = nil
                    }

                confirmationCard(for: pendingConfirmationAction)
                    .padding(.horizontal, 16)
                    .transition(.opacity.combined(with: .scale(scale: 0.98)))
            }
        }
        .tint(AppTheme.accent)
        .navigationTitle("Data Management")
        .animation(.easeInOut(duration: 0.2), value: pendingConfirmationAction != nil)
    }

    @ViewBuilder
    private func confirmationCard(for action: DataManagementConfirmationAction) -> some View {
        switch action {
        case .clearGoal:
            DestructiveConfirmationCardComponent(
                title: "Delete current goal?",
                message: "This removes your target value but keeps all logged weight entries.",
                confirmTitle: "Delete Goal",
                tint: AppTheme.warning,
                isDisabled: viewModel.isPerformingAction,
                onCancel: {
                    pendingConfirmationAction = nil
                },
                onConfirm: {
                    Task {
                        if Task.isCancelled { return }
                        await viewModel.clearGoal()
                        pendingConfirmationAction = nil
                    }
                }
            )
        case .resetPreferences:
            DestructiveConfirmationCardComponent(
                title: "Reset preferences?",
                message: "This resets units, reminder schedule, history filter, and HealthKit sync settings.",
                confirmTitle: "Reset",
                tint: AppTheme.accent,
                isDisabled: viewModel.isPerformingAction,
                onCancel: {
                    pendingConfirmationAction = nil
                },
                onConfirm: {
                    Task {
                        if Task.isCancelled { return }
                        await viewModel.resetPreferences()
                        pendingConfirmationAction = nil
                    }
                }
            )
        case .wipeAllData:
            DestructiveConfirmationCardComponent(
                title: "Wipe all data from this app?",
                message: "This permanently removes all entries, goal, reminder schedule, and preferences including HealthKit sync.",
                confirmTitle: "Wipe All Data",
                tint: AppTheme.error,
                isDisabled: viewModel.isPerformingAction,
                onCancel: {
                    pendingConfirmationAction = nil
                },
                onConfirm: {
                    Task {
                        if Task.isCancelled { return }
                        await viewModel.wipeAllData()
                        pendingConfirmationAction = nil
                    }
                }
            )
        }
    }

    private func sectionTitle(_ title: String) -> some View {
        Text(title.uppercased())
            .font(.caption.weight(.bold))
            .foregroundStyle(AppTheme.muted)
    }
}

#if DEBUG
    #Preview {
        NavigationStack {
            DataManagementView(serviceContainer: PreviewServiceContainer())
        }
    }
#endif
