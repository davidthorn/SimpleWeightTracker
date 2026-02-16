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

    internal init(serviceContainer: ServiceContainerProtocol) {
        let vm = GoalSetupViewModel(serviceContainer: serviceContainer)
        _viewModel = StateObject(wrappedValue: vm)
        _showingDeleteConfirmation = State(initialValue: false)
    }

    internal var body: some View {
        ZStack {
            AppTheme.pageGradient
                .ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 14) {
                    GoalSetupHeroCardComponent()

                    GoalSetupFormFieldsComponent(
                        targetValueText: $viewModel.targetValueText,
                        selectedUnit: $viewModel.selectedUnit
                    )

                    if let errorMessage = viewModel.errorMessage {
                        FormErrorCardComponent(message: errorMessage)
                    }

                    GoalSetupActionButtonsComponent(
                        canSave: viewModel.canSave,
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
        .confirmationDialog("Are you sure you want to delete this?", isPresented: $showingDeleteConfirmation, titleVisibility: .visible) {
            Button("Delete", role: .destructive) {
                Task {
                    if Task.isCancelled { return }
                    let didDelete = await viewModel.deleteGoal()
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
            GoalSetupView(serviceContainer: PreviewServiceContainer())
        }
    }
#endif
