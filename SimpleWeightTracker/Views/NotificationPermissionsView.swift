//
//  NotificationPermissionsView.swift
//  SimpleWeightTracker
//
//  Created by David Thorn on 15.02.2026.
//

import SwiftUI
import UIKit

internal struct NotificationPermissionsView: View {
    @Environment(\.openURL) private var openURL
    @StateObject private var viewModel: NotificationPermissionsViewModel

    internal init(serviceContainer: ServiceContainerProtocol) {
        let vm = NotificationPermissionsViewModel(serviceContainer: serviceContainer)
        _viewModel = StateObject(wrappedValue: vm)
    }

    internal var body: some View {
        ZStack {
            AppTheme.pageGradient
                .ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 14) {
                    NotificationPermissionsHeaderCardComponent()
                    permissionStateCard

                    if let errorMessage = viewModel.errorMessage {
                        FormErrorCardComponent(message: errorMessage)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
            }
        }
        .tint(AppTheme.accent)
        .navigationTitle("Permissions")
        .task {
            if Task.isCancelled { return }
            await viewModel.load()
        }
        .task {
            if Task.isCancelled { return }
            await viewModel.observeAuthorizationStatusChanges()
        }
    }

    @ViewBuilder
    private var permissionStateCard: some View {
        switch viewModel.status {
        case .notDetermined:
            NotificationPermissionStateCardComponent(
                title: "Allow Notifications",
                message: "Enable reminders so the app can nudge you to log your weight during the day.",
                systemImage: "hand.raised.fill",
                tint: AppTheme.accent,
                actionTitle: "Request Permission",
                actionSystemImage: "bell.badge.fill",
                actionTint: AppTheme.accent
            ) {
                Task {
                    if Task.isCancelled { return }
                    await viewModel.requestAuthorization()
                }
            }
        case .authorized, .provisional:
            NotificationPermissionStateCardComponent(
                title: "Permission Approved",
                message: "Notifications are enabled. Your reminders can be delivered as configured.",
                systemImage: "checkmark.seal.fill",
                tint: AppTheme.success
            ) {}
        case .denied:
            NotificationPermissionStateCardComponent(
                title: "Permission Denied",
                message: "Notifications are currently blocked. Open Settings and enable notifications for this app.",
                systemImage: "exclamationmark.triangle.fill",
                tint: AppTheme.error,
                actionTitle: "Open Settings",
                actionSystemImage: "gearshape.fill",
                actionTint: AppTheme.error
            ) {
                guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else {
                    return
                }
                openURL(settingsURL)
            }
        }
    }
}

#if DEBUG
    #Preview {
        NavigationStack {
            NotificationPermissionsView(serviceContainer: PreviewServiceContainer())
        }
    }
#endif
