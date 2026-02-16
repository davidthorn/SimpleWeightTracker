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

    internal init(serviceContainer: ServiceContainerProtocol) {
        let vm = UnitsSettingsViewModel(serviceContainer: serviceContainer)
        _viewModel = StateObject(wrappedValue: vm)
        _showingDeleteConfirmation = State(initialValue: false)
    }

    internal var body: some View {
        ZStack {
            AppTheme.pageGradient
                .ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 14) {
                    UnitsSettingsHeroCardComponent()

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
        .confirmationDialog("Are you sure you want to delete this?", isPresented: $showingDeleteConfirmation, titleVisibility: .visible) {
            Button("Delete", role: .destructive) {
                Task {
                    if Task.isCancelled { return }
                    await viewModel.deletePreference()
                    dismiss()
                }
            }
            Button("Cancel", role: .cancel) {}
        }
    }
}

#if DEBUG
    #Preview {
        NavigationStack {
            UnitsSettingsView(serviceContainer: PreviewServiceContainer())
        }
    }
#endif
