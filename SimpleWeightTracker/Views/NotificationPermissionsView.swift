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
                    headerCard
                    permissionStateCard

                    if let errorMessage = viewModel.errorMessage {
                        errorCard(errorMessage)
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

    private var headerCard: some View {
        HStack(alignment: .top, spacing: 10) {
            Image(systemName: "bell.badge.fill")
                .font(.subheadline.weight(.bold))
                .foregroundStyle(AppTheme.warning)
                .padding(9)
                .background(
                    Circle()
                        .fill(AppTheme.warning.opacity(0.14))
                )

            VStack(alignment: .leading, spacing: 3) {
                Text("Notification Permission")
                    .font(.headline)
                Text("Weight reminders help you keep your logging routine consistent.")
                    .font(.footnote)
                    .foregroundStyle(AppTheme.muted)
            }
            Spacer()
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(AppTheme.cardBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .stroke(AppTheme.warning.opacity(0.2), lineWidth: 1)
                )
        )
    }

    @ViewBuilder
    private var permissionStateCard: some View {
        switch viewModel.status {
        case .notDetermined:
            permissionCard(
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
            permissionCard(
                title: "Permission Approved",
                message: "Notifications are enabled. Your reminders can be delivered as configured.",
                systemImage: "checkmark.seal.fill",
                tint: AppTheme.success
            ) {}
        case .denied:
            permissionCard(
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

    private func permissionCard(
        title: String,
        message: String,
        systemImage: String,
        tint: Color,
        actionTitle: String? = nil,
        actionSystemImage: String? = nil,
        actionTint: Color? = nil,
        action: @escaping () -> Void
    ) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .top, spacing: 10) {
                Image(systemName: systemImage)
                    .font(.subheadline.weight(.bold))
                    .foregroundStyle(tint)
                    .padding(9)
                    .background(
                        Circle()
                            .fill(tint.opacity(0.14))
                    )

                VStack(alignment: .leading, spacing: 3) {
                    Text(title)
                        .font(.headline)
                    Text(message)
                        .font(.footnote)
                        .foregroundStyle(AppTheme.muted)
                }
                Spacer()
            }

            if let actionTitle, let actionSystemImage, let actionTint {
                actionButton(
                    title: actionTitle,
                    systemImage: actionSystemImage,
                    tint: actionTint,
                    action: action
                )
            }
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(AppTheme.cardBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .stroke(tint.opacity(0.2), lineWidth: 1)
                )
        )
    }

    private func actionButton(title: String, systemImage: String, tint: Color, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Label(title, systemImage: systemImage)
                .font(.subheadline.weight(.semibold))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
        }
        .buttonStyle(.plain)
        .foregroundStyle(.white)
        .background(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(tint)
        )
    }

    private func errorCard(_ message: String) -> some View {
        Text(message)
            .font(.footnote)
            .foregroundStyle(AppTheme.error)
            .padding(12)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(AppTheme.error.opacity(0.08))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .stroke(AppTheme.error.opacity(0.24), lineWidth: 1)
                    )
            )
    }
}

#if DEBUG
    #Preview {
        NavigationStack {
            NotificationPermissionsView(serviceContainer: PreviewServiceContainer())
        }
    }
#endif
