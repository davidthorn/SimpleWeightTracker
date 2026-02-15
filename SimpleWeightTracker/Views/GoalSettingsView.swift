//
//  GoalSettingsView.swift
//  SimpleWeightTracker
//
//  Created by David Thorn on 15.02.2026.
//

import SwiftUI

internal struct GoalSettingsView: View {
    private let serviceContainer: ServiceContainerProtocol

    internal init(serviceContainer: ServiceContainerProtocol) {
        self.serviceContainer = serviceContainer
    }

    internal var body: some View {
        GoalSetupView(serviceContainer: serviceContainer)
            .navigationTitle("Goal Settings")
    }
}

#if DEBUG
    #Preview {
        NavigationStack {
            GoalSettingsView(serviceContainer: PreviewServiceContainer())
        }
    }
#endif
