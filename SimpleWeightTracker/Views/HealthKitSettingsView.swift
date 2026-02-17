//
//  HealthKitSettingsView.swift
//  SimpleWeightTracker
//
//  Created by David Thorn on 16.02.2026.
//

import SwiftUI
import SimpleFramework
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
                    SimpleHeroCard(
                        title: "Health Integration",
                        message: "Choose whether new weight entries should be written to Apple Health.",
                        systemImage: "heart.text.square.fill",
                        tint: AppTheme.error
                    )

                    SimpleHealthKitPermissionsCard(
                        permissionState: frameworkPermissionState,
                        statusSummaryText: viewModel.statusSummaryText,
                        isHealthKitAvailable: viewModel.isHealthKitAvailable,
                        accentTint: AppTheme.warning,
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

                    SimpleHealthKitAutoSyncCard(
                        isAutoSyncEnabled: Binding(
                            get: { viewModel.isAutoSyncEnabled },
                            set: { newValue in
                                Task {
                                    if Task.isCancelled { return }
                                    await viewModel.setAutoSyncEnabled(newValue)
                                }
                            }
                        ),
                        isHealthKitAvailable: viewModel.isHealthKitAvailable,
                        tint: AppTheme.success
                    )

                    if let errorMessage = viewModel.errorMessage {
                        SimpleFormErrorCard(message: errorMessage, tint: AppTheme.error)
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

    private var frameworkPermissionState: SimpleFramework.HealthKitPermissionState {
        let read = SimpleFramework.HealthKitAuthorizationState(rawValue: viewModel.permissionState.read.rawValue) ?? .unavailable
        let write = SimpleFramework.HealthKitAuthorizationState(rawValue: viewModel.permissionState.write.rawValue) ?? .unavailable
        return SimpleFramework.HealthKitPermissionState(read: read, write: write)
    }
}

#if DEBUG
    #Preview {
        NavigationStack {
            HealthKitSettingsView(serviceContainer: PreviewServiceContainer())
        }
    }
#endif
