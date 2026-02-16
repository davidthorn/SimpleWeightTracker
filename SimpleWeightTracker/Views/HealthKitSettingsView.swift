//
//  HealthKitSettingsView.swift
//  SimpleWeightTracker
//
//  Created by David Thorn on 16.02.2026.
//

import SwiftUI
import UIKit

internal struct HealthKitSettingsView: View {
    @Environment(\.openURL) private var openURL
    @StateObject private var viewModel: HealthKitSettingsViewModel

    internal init(serviceContainer: ServiceContainerProtocol) {
        let vm = HealthKitSettingsViewModel(serviceContainer: serviceContainer)
        _viewModel = StateObject(wrappedValue: vm)
    }

    internal var body: some View {
        ZStack {
            AppTheme.pageGradient
                .ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 14) {
                    ThemedHeroHeaderCardComponent(
                        title: "Health Integration",
                        subtitle: "Choose whether new weight entries should be written to Apple Health.",
                        systemImage: "heart.text.square.fill",
                        tint: AppTheme.error
                    )

                    HealthKitPermissionsCardComponent(
                        permissionState: viewModel.permissionState,
                        statusSummaryText: viewModel.statusSummaryText,
                        isHealthKitAvailable: viewModel.isHealthKitAvailable,
                        onRequestAccess: {
                            Task {
                                if Task.isCancelled { return }
                                await viewModel.requestPermissions()
                            }
                        },
                        onOpenSettings: {
                            guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else {
                                return
                            }
                            openURL(settingsURL)
                        }
                    )

                    HealthKitAutoSyncCardComponent(
                        isAutoSyncEnabled: Binding(
                            get: { viewModel.isAutoSyncEnabled },
                            set: { newValue in
                                Task {
                                    if Task.isCancelled { return }
                                    await viewModel.setAutoSyncEnabled(newValue)
                                }
                            }
                        ),
                        isHealthKitAvailable: viewModel.isHealthKitAvailable
                    )

                    if let errorMessage = viewModel.errorMessage {
                        FormErrorCardComponent(message: errorMessage)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
            }
        }
        .navigationTitle("HealthKit")
        .tint(AppTheme.accent)
        .task {
            if Task.isCancelled { return }
            await viewModel.load()
        }
        .task {
            if Task.isCancelled { return }
            await viewModel.observeAutoSync()
        }
        .task {
            if Task.isCancelled { return }
            await viewModel.observeAppDidBecomeActive()
        }
    }
}

#if DEBUG
    #Preview {
        NavigationStack {
            HealthKitSettingsView(serviceContainer: PreviewServiceContainer())
        }
    }
#endif
