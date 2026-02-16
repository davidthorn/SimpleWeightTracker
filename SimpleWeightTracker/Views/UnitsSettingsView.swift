//
//  UnitsSettingsView.swift
//  SimpleWeightTracker
//
//  Created by David Thorn on 15.02.2026.
//

import SwiftUI

internal struct UnitsSettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel: UnitsSettingsViewModel
    @State private var showingDeleteConfirmation: Bool
    @State private var isDeletingPreference: Bool

    internal init(serviceContainer: ServiceContainerProtocol) {
        let vm = UnitsSettingsViewModel(serviceContainer: serviceContainer)
        _viewModel = StateObject(wrappedValue: vm)
        _showingDeleteConfirmation = State(initialValue: false)
        _isDeletingPreference = State(initialValue: false)
    }

    internal var body: some View {
        ZStack {
            AppTheme.pageGradient
                .ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 14) {
                    ThemedHeroHeaderCardComponent(
                        title: "Unit Preference",
                        subtitle: "Pick your base measurement language.",
                        systemImage: "scalemass",
                        tint: AppTheme.accent
                    )

                    UnitsSettingsFormCardComponent(selectedUnit: $viewModel.selectedUnit)

                    UnitsSettingsActionButtonsComponent(
                        hasChanges: viewModel.hasChanges,
                        onSave: {
                            Task {
                                if Task.isCancelled { return }
                                await viewModel.save()
                                dismiss()
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
                        if isDeletingPreference { return }
                        showingDeleteConfirmation = false
                    }

                DestructiveConfirmationCardComponent(
                    title: "Delete unit preference?",
                    message: "This removes your saved preference and restores the app default.",
                    confirmTitle: "Delete Preference",
                    tint: AppTheme.error,
                    isDisabled: isDeletingPreference,
                    onCancel: {
                        showingDeleteConfirmation = false
                    },
                    onConfirm: {
                        Task {
                            if Task.isCancelled { return }
                            isDeletingPreference = true
                            await viewModel.deletePreference()
                            isDeletingPreference = false
                            dismiss()
                        }
                    }
                )
                .padding(.horizontal, 16)
                .transition(.opacity.combined(with: .scale(scale: 0.98)))
            }
        }
        .tint(AppTheme.accent)
        .navigationTitle("Units")
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
            UnitsSettingsView(serviceContainer: PreviewServiceContainer())
        }
    }
#endif
