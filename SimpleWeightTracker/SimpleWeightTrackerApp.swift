//
//  SimpleWeightTrackerApp.swift
//  SimpleWeightTracker
//
//  Created by David Thorn on 15.02.26.
//

import SwiftUI

@main
struct SimpleWeightTrackerApp: App {
    @State private var hasAttemptedBootstrap: Bool
    private let serviceContainer: ServiceContainerProtocol

    init() {
        serviceContainer = ServiceContainer()
        _hasAttemptedBootstrap = State(initialValue: false)
    }

    var body: some Scene {
        WindowGroup {
            ContentView(serviceContainer: serviceContainer)
                .task {
                    await bootstrapDebugDataIfNeeded()
                }
        }
    }

    @MainActor
    private func bootstrapDebugDataIfNeeded() async {
        if Task.isCancelled { return }

        guard hasAttemptedBootstrap == false else {
            return
        }
        hasAttemptedBootstrap = true

        #if DEBUG
            if let debugBootstrapService = serviceContainer.weightEntryService as? WeightEntryDebugBootstrapServiceProtocol {
                do {
                    try await debugBootstrapService.bootstrapIfNeeded()
                } catch {
                    // Ignore bootstrap errors in debug; app should still launch.
                }
            }

            if let debugBootstrapService = serviceContainer.goalService as? GoalDebugBootstrapServiceProtocol {
                do {
                    try await debugBootstrapService.bootstrapIfNeeded()
                } catch {
                    // Ignore bootstrap errors in debug; app should still launch.
                }
            }
        #endif
    }
}
