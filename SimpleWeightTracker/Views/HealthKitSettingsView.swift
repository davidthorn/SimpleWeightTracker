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
                    headerCard
                    permissionCard
                    autoSyncCard

                    if let errorMessage = viewModel.errorMessage {
                        errorCard(errorMessage)
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

    private var headerCard: some View {
        HStack(alignment: .top, spacing: 10) {
            Image(systemName: "heart.text.square.fill")
                .font(.subheadline.weight(.bold))
                .foregroundStyle(AppTheme.error)
                .padding(9)
                .background(
                    Circle()
                        .fill(AppTheme.error.opacity(0.14))
                )

            VStack(alignment: .leading, spacing: 3) {
                Text("Health Integration")
                    .font(.headline)
                Text("Choose whether new weight entries should be written to Apple Health.")
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
                        .stroke(AppTheme.error.opacity(0.2), lineWidth: 1)
                )
        )
    }

    private var permissionCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Weight Permissions")
                .font(.subheadline.weight(.semibold))

            HStack(spacing: 10) {
                permissionStatePill(
                    title: "Read",
                    state: viewModel.permissionState.read
                )
                permissionStatePill(
                    title: "Write",
                    state: viewModel.permissionState.write
                )
            }

            Text(viewModel.statusSummaryText)
                .font(.footnote)
                .foregroundStyle(AppTheme.muted)

            if viewModel.isHealthKitAvailable {
                HStack(spacing: 10) {
                    actionButton(
                        title: "Request Access",
                        systemImage: "heart.fill",
                        tint: AppTheme.accent
                    ) {
                        Task {
                            if Task.isCancelled { return }
                            await viewModel.requestPermissions()
                        }
                    }

                    if viewModel.permissionState.read == .denied || viewModel.permissionState.write == .denied {
                        actionButton(
                            title: "Open Settings",
                            systemImage: "gearshape.fill",
                            tint: AppTheme.warning
                        ) {
                            guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else {
                                return
                            }
                            openURL(settingsURL)
                        }
                    }
                }
            }
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(AppTheme.cardBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .stroke(AppTheme.border, lineWidth: 1)
                )
        )
    }

    private var autoSyncCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 10) {
                Image(systemName: "arrow.triangle.2.circlepath")
                    .font(.subheadline.weight(.bold))
                    .foregroundStyle(AppTheme.success)
                    .frame(width: 28, height: 28)
                    .background(
                        RoundedRectangle(cornerRadius: 8, style: .continuous)
                            .fill(AppTheme.success.opacity(0.12))
                    )

                VStack(alignment: .leading, spacing: 3) {
                    Text("Auto-Sync New Entries")
                        .font(.subheadline.weight(.semibold))
                    Text("When enabled, newly created weight logs are also saved to HealthKit.")
                        .font(.footnote)
                        .foregroundStyle(AppTheme.muted)
                }

                Spacer()

                Toggle("", isOn: Binding(
                    get: { viewModel.isAutoSyncEnabled },
                    set: { newValue in
                        Task {
                            if Task.isCancelled { return }
                            await viewModel.setAutoSyncEnabled(newValue)
                        }
                    }
                ))
                .labelsHidden()
                .disabled(viewModel.isHealthKitAvailable == false)
            }
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(AppTheme.cardBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .stroke(AppTheme.border, lineWidth: 1)
                )
        )
    }

    private func permissionStatePill(title: String, state: HealthKitAuthorizationState) -> some View {
        let tint = tint(for: state)

        return VStack(alignment: .leading, spacing: 4) {
            Text(title.uppercased())
                .font(.caption2.weight(.bold))
                .foregroundStyle(AppTheme.muted)
            Text(state.displayText)
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(.primary)
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .fill(tint.opacity(0.12))
                .overlay(
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .stroke(tint.opacity(0.3), lineWidth: 1)
                )
        )
    }

    private func tint(for state: HealthKitAuthorizationState) -> Color {
        switch state {
        case .authorized:
            return AppTheme.success
        case .denied:
            return AppTheme.error
        case .notDetermined:
            return AppTheme.warning
        case .unavailable:
            return AppTheme.muted
        }
    }

    private func actionButton(title: String, systemImage: String, tint: Color, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Label(title, systemImage: systemImage)
                .font(.footnote.weight(.semibold))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 10)
        }
        .buttonStyle(.plain)
        .foregroundStyle(.white)
        .background(
            RoundedRectangle(cornerRadius: 10, style: .continuous)
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
            HealthKitSettingsView(serviceContainer: PreviewServiceContainer())
        }
    }
#endif
