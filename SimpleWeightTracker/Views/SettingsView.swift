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
                    heroCard

                    VStack(spacing: 10) {
                        NavigationLink(value: SettingsRoute.goal) {
                            routeRow(
                                title: "Goal",
                                subtitle: "Target: gain, lose, or maintain",
                                systemImage: "target",
                                tint: AppTheme.accent
                            )
                        }
                        .buttonStyle(.plain)

                        NavigationLink(value: SettingsRoute.units) {
                            routeRow(
                                title: "Units",
                                subtitle: "Current: \(viewModel.unit == .kilograms ? "kg" : "lb")",
                                systemImage: "ruler",
                                tint: AppTheme.success
                            )
                        }
                        .buttonStyle(.plain)

                        NavigationLink(value: SettingsRoute.reminders) {
                            routeRow(
                                title: "Reminder Schedule",
                                subtitle: "Configure reminder frequency",
                                systemImage: "bell.badge.fill",
                                tint: AppTheme.warning
                            )
                        }
                        .buttonStyle(.plain)

                        NavigationLink(value: SettingsRoute.notificationPermissions) {
                            routeRow(
                                title: "Notification Permissions",
                                subtitle: "Status: \(viewModel.reminderStatus.rawValue)",
                                systemImage: "bell.circle.fill",
                                tint: AppTheme.accent
                            )
                        }
                        .buttonStyle(.plain)

                        NavigationLink(value: SettingsRoute.healthKit) {
                            routeRow(
                                title: "HealthKit",
                                subtitle: viewModel.healthKitSubtitle,
                                systemImage: "heart.text.square.fill",
                                tint: AppTheme.success
                            )
                        }
                        .buttonStyle(.plain)

                        NavigationLink(value: SettingsRoute.dataManagement) {
                            routeRow(
                                title: "Data Management",
                                subtitle: "Reset goals and preferences",
                                systemImage: "trash.circle.fill",
                                tint: AppTheme.error
                            )
                        }
                        .buttonStyle(.plain)
                    }
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

    private var heroCard: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: "slider.horizontal.3")
                .font(.title3.weight(.semibold))
                .foregroundStyle(AppTheme.accent)
                .frame(width: 30, height: 30)

            VStack(alignment: .leading, spacing: 6) {
                Text("Preferences & Tracking")
                    .font(.headline)
                Text("Tune your weight tracking experience with units, goals, reminders, and data controls.")
                    .font(.footnote)
                    .foregroundStyle(AppTheme.muted)
            }
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(AppTheme.cardBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .stroke(AppTheme.accent.opacity(0.2), lineWidth: 1)
                )
        )
    }

    private func routeRow(title: String, subtitle: String, systemImage: String, tint: Color) -> some View {
        HStack(spacing: 12) {
            Image(systemName: systemImage)
                .font(.body.weight(.semibold))
                .foregroundStyle(tint)
                .frame(width: 30, height: 30)
                .background(
                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                        .fill(tint.opacity(0.14))
                )

            VStack(alignment: .leading, spacing: 3) {
                Text(title)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.primary)
                Text(subtitle)
                    .font(.caption)
                    .foregroundStyle(AppTheme.muted)
            }

            Spacer()

            Image(systemName: "chevron.right")
                .font(.caption.weight(.semibold))
                .foregroundStyle(.secondary)
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(AppTheme.cardBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .stroke(AppTheme.border, lineWidth: 1)
                )
        )
    }
}

#if DEBUG
    #Preview {
        NavigationStack {
            SettingsView(serviceContainer: PreviewServiceContainer())
        }
    }
#endif
