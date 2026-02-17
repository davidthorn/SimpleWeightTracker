//
//  SettingsView.swift
//  SimpleWeightTracker
//
//  Created by David Thorn on 15.02.2026.
//

import SwiftUI
import SimpleFramework

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
                    SimpleHeroCard(
                        title: "Preferences & Tracking",
                        message: "Tune your weight tracking experience with units, goals, reminders, and data controls.",
                        systemImage: "slider.horizontal.3",
                        tint: AppTheme.accent
                    )

                    SimpleRouteSection(title: "Preferences") {
                        NavigationLink(value: SettingsRoute.goal) {
                            SimpleRouteRow(
                                title: "Goal",
                                subtitle: "Target: gain, lose, or maintain",
                                systemImage: "target",
                                tint: AppTheme.accent
                            )
                        }
                        .buttonStyle(.plain)

                        NavigationLink(value: SettingsRoute.units) {
                            SimpleRouteRow(
                                title: "Units",
                                subtitle: "Current: \(viewModel.unit == .kilograms ? "kg" : "lb")",
                                systemImage: "ruler",
                                tint: AppTheme.success
                            )
                        }
                        .buttonStyle(.plain)

                        NavigationLink(value: SettingsRoute.reminders) {
                            SimpleRouteRow(
                                title: "Reminder Schedule",
                                subtitle: "Configure reminder frequency",
                                systemImage: "bell.badge.fill",
                                tint: AppTheme.warning
                            )
                        }
                        .buttonStyle(.plain)

                        NavigationLink(value: SettingsRoute.notificationPermissions) {
                            SimpleRouteRow(
                                title: "Notification Permissions",
                                subtitle: "Status: \(viewModel.reminderStatus.rawValue)",
                                systemImage: "bell.circle.fill",
                                tint: AppTheme.accent
                            )
                        }
                        .buttonStyle(.plain)
                    }

                    SimpleRouteSection(title: "Integrations") {
                        NavigationLink(value: SettingsRoute.healthKit) {
                            SimpleRouteRow(
                                title: "HealthKit",
                                subtitle: viewModel.healthKitSubtitle,
                                systemImage: "heart.text.square.fill",
                                tint: AppTheme.success
                            )
                        }
                        .buttonStyle(.plain)
                    }

                    SimpleRouteSection(title: "Data") {
                        NavigationLink(value: SettingsRoute.dataManagement) {
                            SimpleRouteRow(
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
}

#if DEBUG
    #Preview {
        NavigationStack {
            SettingsView(serviceContainer: PreviewServiceContainer())
        }
    }
#endif
