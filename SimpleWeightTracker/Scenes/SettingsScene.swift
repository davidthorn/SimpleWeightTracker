//
//  SettingsScene.swift
//  SimpleWeightTracker
//
//  Created by David Thorn on 15.02.2026.
//

import SwiftUI

internal struct SettingsScene: View {
    private let serviceContainer: ServiceContainerProtocol
    @State private var path: [SettingsRoute]

    internal init(serviceContainer: ServiceContainerProtocol) {
        self.serviceContainer = serviceContainer
        _path = State(initialValue: [])
    }

    internal var body: some View {
        NavigationStack(path: $path) {
            SettingsView(serviceContainer: serviceContainer)
                .navigationDestination(for: SettingsRoute.self) { route in
                    switch route {
                    case .goal:
                        GoalSettingsView(serviceContainer: serviceContainer)
                    case .units:
                        UnitsSettingsView(serviceContainer: serviceContainer)
                    case .reminders:
                        ReminderSettingsView(serviceContainer: serviceContainer)
                    case .notificationPermissions:
                        NotificationPermissionsView(serviceContainer: serviceContainer)
                    case .dataManagement:
                        DataManagementView(serviceContainer: serviceContainer)
                    }
                }
        }
    }
}

#if DEBUG
    #Preview {
        SettingsScene(serviceContainer: PreviewServiceContainer())
    }
#endif
