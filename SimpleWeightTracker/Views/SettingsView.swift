//
//  SettingsView.swift
//  SimpleWeightTracker
//
//  Created by David Thorn on 15.02.2026.
//

import SwiftUI

internal struct SettingsView: View {
    @StateObject private var viewModel: SettingsViewModel

    internal init(serviceContainer: ServiceContainerProtocol) {
        let vm = SettingsViewModel(serviceContainer: serviceContainer)
        _viewModel = StateObject(wrappedValue: vm)
    }

    internal var body: some View {
        ZStack {
            AppTheme.pageGradient
                .ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 14) {
                    SettingsHeroCardComponent()

                    SettingsRoutesListComponent(
                        unitLabel: viewModel.unit == .kilograms ? "kg" : "lb",
                        reminderStatusText: viewModel.reminderStatus.rawValue,
                        healthKitSubtitle: viewModel.healthKitSubtitle
                    )
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
            }
        }
        .navigationTitle("Settings")
        .task {
            if Task.isCancelled { return }
            await viewModel.load()
        }
        .task {
            if Task.isCancelled { return }
            await viewModel.observeUnit()
        }
    }
}

#if DEBUG
    #Preview {
        NavigationStack {
            SettingsView(serviceContainer: PreviewServiceContainer())
        }
    }
#endif
