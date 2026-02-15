//
//  DataManagementView.swift
//  SimpleWeightTracker
//
//  Created by David Thorn on 15.02.2026.
//

import SwiftUI

internal struct DataManagementView: View {
    @StateObject private var viewModel: DataManagementViewModel
    @State private var showingGoalDeleteConfirmation: Bool
    @State private var showingResetConfirmation: Bool

    internal init(serviceContainer: ServiceContainerProtocol) {
        let vm = DataManagementViewModel(serviceContainer: serviceContainer)
        _viewModel = StateObject(wrappedValue: vm)
        _showingGoalDeleteConfirmation = State(initialValue: false)
        _showingResetConfirmation = State(initialValue: false)
    }

    internal var body: some View {
        List {
            Button("Delete Goal", role: .destructive) {
                showingGoalDeleteConfirmation = true
            }

            Button("Reset Preferences", role: .destructive) {
                showingResetConfirmation = true
            }

            if let message = viewModel.message {
                Text(message)
                    .foregroundStyle(.secondary)
            }
        }
        .scrollContentBackground(.hidden)
        .background(AppTheme.pageGradient.ignoresSafeArea())
        .listRowBackground(AppTheme.cardBackground)
        .tint(AppTheme.accent)
        .navigationTitle("Data Management")
        .confirmationDialog("Are you sure you want to delete this?", isPresented: $showingGoalDeleteConfirmation, titleVisibility: .visible) {
            Button("Delete", role: .destructive) {
                Task {
                    if Task.isCancelled { return }
                    await viewModel.clearGoal()
                }
            }
            Button("Cancel", role: .cancel) {}
        }
        .confirmationDialog("Are you sure you want to delete this?", isPresented: $showingResetConfirmation, titleVisibility: .visible) {
            Button("Delete", role: .destructive) {
                Task {
                    if Task.isCancelled { return }
                    await viewModel.resetPreferences()
                }
            }
            Button("Cancel", role: .cancel) {}
        }
    }
}

#if DEBUG
    #Preview {
        NavigationStack {
            DataManagementView(serviceContainer: PreviewServiceContainer())
        }
    }
#endif
