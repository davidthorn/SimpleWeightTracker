//
//  SettingsRoutesListComponent.swift
//  SimpleWeightTracker
//
//  Created by David Thorn on 16.02.2026.
//

import SwiftUI

internal struct SettingsRoutesListComponent: View {
    private let unitLabel: String
    private let reminderStatusText: String
    private let healthKitSubtitle: String

    internal init(unitLabel: String, reminderStatusText: String, healthKitSubtitle: String) {
        self.unitLabel = unitLabel
        self.reminderStatusText = reminderStatusText
        self.healthKitSubtitle = healthKitSubtitle
    }

    internal var body: some View {
        VStack(spacing: 10) {
            NavigationLink(value: SettingsRoute.goal) {
                RouteRowComponent(
                    title: "Goal",
                    subtitle: "Target: gain, lose, or maintain",
                    systemImage: "target",
                    tint: AppTheme.accent
                )
            }
            .buttonStyle(.plain)

            NavigationLink(value: SettingsRoute.units) {
                RouteRowComponent(
                    title: "Units",
                    subtitle: "Current: \(unitLabel)",
                    systemImage: "ruler",
                    tint: AppTheme.success
                )
            }
            .buttonStyle(.plain)

            NavigationLink(value: SettingsRoute.reminders) {
                RouteRowComponent(
                    title: "Reminder Schedule",
                    subtitle: "Configure reminder frequency",
                    systemImage: "bell.badge.fill",
                    tint: AppTheme.warning
                )
            }
            .buttonStyle(.plain)

            NavigationLink(value: SettingsRoute.notificationPermissions) {
                RouteRowComponent(
                    title: "Notification Permissions",
                    subtitle: "Status: \(reminderStatusText)",
                    systemImage: "bell.circle.fill",
                    tint: AppTheme.accent
                )
            }
            .buttonStyle(.plain)

            NavigationLink(value: SettingsRoute.healthKit) {
                RouteRowComponent(
                    title: "HealthKit",
                    subtitle: healthKitSubtitle,
                    systemImage: "heart.text.square.fill",
                    tint: AppTheme.success
                )
            }
            .buttonStyle(.plain)

            NavigationLink(value: SettingsRoute.dataManagement) {
                RouteRowComponent(
                    title: "Data Management",
                    subtitle: "Reset goals and preferences",
                    systemImage: "trash.circle.fill",
                    tint: AppTheme.error
                )
            }
            .buttonStyle(.plain)
        }
    }
}

#if DEBUG
    #Preview {
        NavigationStack {
            SettingsRoutesListComponent(
                unitLabel: "kg",
                reminderStatusText: "notDetermined",
                healthKitSubtitle: "Read: Authorized • Write: Authorized"
            )
            .padding()
            .background(AppTheme.pageGradient)
        }
    }
#endif
