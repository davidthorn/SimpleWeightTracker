//
//  GoalSetupView.swift
//  SimpleWeightTracker
//
//  Created by David Thorn on 15.02.2026.
//

import SwiftUI
import SimpleFramework

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
                    SimpleHeroCard(
                        title: "Target Setup",
                        message: "Define the number you are moving toward.",
                        systemImage: "target",
                        tint: AppTheme.accent
                    )

                    SimpleLabeledTextFieldCard(
                        text: $viewModel.targetValueText,
                        title: "Target Weight",
                        placeholder: "e.g. 70.0",
                        helperText: "Unit: \(viewModel.selectedUnit == .kilograms ? "kg" : "lb")"
                    )
                    .keyboardType(.decimalPad)

                    SimpleSegmentedChoiceCard(
                        selectedValue: selectedUnitBinding,
                        title: "Unit",
                        options: unitOptions
                    )

                    if let errorMessage = viewModel.errorMessage {
                        SimpleFormErrorCard(message: errorMessage, tint: AppTheme.error)
                    }

                    SimpleFormActionButtons(
                        showSave: viewModel.canSave,
                        showReset: viewModel.isPersisted && viewModel.hasChanges,
                        showDelete: viewModel.isPersisted,
                        saveTitle: "Save Target",
                        deleteTitle: "Delete Target",
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

                SimpleDestructiveConfirmationCard(
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

    private var unitOptions: [SimpleSegmentedChoiceOption] {
        [
            SimpleSegmentedChoiceOption(title: "KG", value: WeightUnit.kilograms.rawValue),
            SimpleSegmentedChoiceOption(title: "LB", value: WeightUnit.pounds.rawValue)
        ]
    }

    private var selectedUnitBinding: Binding<String> {
        Binding(
            get: { viewModel.selectedUnit.rawValue },
            set: { value in
                if let unit = WeightUnit(rawValue: value) {
                    viewModel.selectedUnit = unit
                }
            }
        )
    }
}

#if DEBUG
    #Preview {
        NavigationStack {
            GoalSetupView(serviceContainer: PreviewServiceContainer())
        }
    }
#endif
