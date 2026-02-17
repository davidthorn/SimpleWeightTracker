//
//  DataManagementView.swift
//  SimpleWeightTracker
//
//  Created by David Thorn on 15.02.2026.
//

import SwiftUI
import SimpleFramework

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
                    SimpleHeroCard(
                        title: "Data Controls",
                        message: "Use these actions carefully. Some operations permanently remove stored data.",
                        systemImage: "externaldrive.badge.exclamationmark",
                        tint: AppTheme.error
                    )

                    sectionTitle("Targeted Actions")

                    SimpleInfoActionCard(
                        title: "Delete Goal",
                        subtitle: "Removes your current target while keeping historical entries.",
                        systemImage: "target",
                        tint: AppTheme.warning,
                        actionTitle: "Delete Goal",
                        actionSystemImage: "trash.fill",
                        actionTint: AppTheme.warning,
                        isActionEnabled: viewModel.isPerformingAction == false
                    ) {
                        pendingConfirmationAction = .clearGoal
                    }

                    SimpleInfoActionCard(
                        title: "Reset Preferences",
                        subtitle: "Resets units, reminder schedule, history filter, and HealthKit sync settings.",
                        systemImage: "slider.horizontal.3",
                        tint: AppTheme.accent,
                        actionTitle: "Reset Preferences",
                        actionSystemImage: "trash.fill",
                        actionTint: AppTheme.accent,
                        isActionEnabled: viewModel.isPerformingAction == false
                    ) {
                        pendingConfirmationAction = .resetPreferences
                    }

                    sectionTitle("Danger Zone")

                    SimpleInfoActionCard(
                        title: "Wipe All Data",
                        subtitle: "Permanently removes all entries, goal, reminder schedule, and preferences including HealthKit sync.",
                        systemImage: "trash.fill",
                        tint: AppTheme.error,
                        actionTitle: "Wipe All Data",
                        actionSystemImage: "trash.fill",
                        actionTint: AppTheme.error,
                        isActionEnabled: viewModel.isPerformingAction == false
                    ) {
                        pendingConfirmationAction = .wipeAllData
                    }

                    if let message = viewModel.message {
                        SimpleFeedbackCard(
                            message: message,
                            tint: viewModel.isErrorMessage ? AppTheme.error : AppTheme.success
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
            SimpleDestructiveConfirmationCard(
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
            SimpleDestructiveConfirmationCard(
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
            SimpleDestructiveConfirmationCard(
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
