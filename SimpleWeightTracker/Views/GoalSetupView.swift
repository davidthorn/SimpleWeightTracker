//
//  GoalSetupView.swift
//  SimpleWeightTracker
//
//  Created by David Thorn on 15.02.2026.
//

import SwiftUI

internal struct GoalSetupView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel: GoalSetupViewModel
    @State private var showingDeleteConfirmation: Bool
    @State private var isDeletingGoal: Bool

    internal init(serviceContainer: ServiceContainerProtocol) {
        let vm = GoalSetupViewModel(serviceContainer: serviceContainer)
        _viewModel = StateObject(wrappedValue: vm)
        _showingDeleteConfirmation = State(initialValue: false)
        _isDeletingGoal = State(initialValue: false)
    }

    internal var body: some View {
        ZStack {
            AppTheme.pageGradient
                .ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 14) {
                    ThemedHeroHeaderCardComponent(
                        title: "Target Setup",
                        subtitle: "Define the number you are moving toward.",
                        systemImage: "target",
                        tint: AppTheme.accent
                    )

                    GoalSetupFormFieldsComponent(
                        targetValueText: $viewModel.targetValueText,
                        selectedUnit: $viewModel.selectedUnit
                    )

                    if let errorMessage = viewModel.errorMessage {
                        FormErrorCardComponent(message: errorMessage)
                    }

                    FormActionButtonsComponent(
                        goalCanSave: viewModel.canSave,
                        isPersisted: viewModel.isPersisted,
                        hasChanges: viewModel.hasChanges,
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
            .scrollDismissesKeyboard(.interactively)

            if showingDeleteConfirmation {
                Color.black.opacity(0.16)
                    .ignoresSafeArea()
                    .onTapGesture {
                        if isDeletingGoal { return }
                        showingDeleteConfirmation = false
                    }

                DestructiveConfirmationCardComponent(
                    title: "Delete current goal?",
                    message: "This removes your target value but keeps all logged weight entries.",
                    confirmTitle: "Delete Goal",
                    tint: AppTheme.error,
                    isDisabled: isDeletingGoal,
                    onCancel: {
                        showingDeleteConfirmation = false
                    },
                    onConfirm: {
                        Task {
                            if Task.isCancelled { return }
                            isDeletingGoal = true
                            let didDelete = await viewModel.deleteGoal()
                            isDeletingGoal = false
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
        .navigationTitle("Goal Setup")
        .task {
            if Task.isCancelled { return }
            await viewModel.load()
        }
        .task {
            if Task.isCancelled { return }
            await viewModel.observeUnit()
        }
        .animation(.easeInOut(duration: 0.2), value: showingDeleteConfirmation)
    }
}

#if DEBUG
    #Preview {
        NavigationStack {
            GoalSetupView(serviceContainer: PreviewServiceContainer())
        }
    }
#endif
