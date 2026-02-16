//
//  ContentView.swift
//  SimpleWeightTracker
//
//  Created by David Thorn on 15.02.2026.
//

import SwiftUI

internal struct ContentView: View {
    private let serviceContainer: ServiceContainerProtocol

    internal init(serviceContainer: ServiceContainerProtocol = ServiceContainer()) {
        self.serviceContainer = serviceContainer
    }

    internal var body: some View {
        TabView {
            HomeScene(serviceContainer: serviceContainer)
                .tabItem {
                    Label("Home", systemImage: "house")
                }

            HistoryScene(serviceContainer: serviceContainer)
                .tabItem {
                    Label("History", systemImage: "clock.arrow.circlepath")
                }

            WeightProgressScene(serviceContainer: serviceContainer)
                .tabItem {
                    Label("Progress", systemImage: "chart.line.uptrend.xyaxis")
                }

            SettingsScene(serviceContainer: serviceContainer)
                .tabItem {
                    Label("Settings", systemImage: "gearshape")
                }
        }
    }
}

#if DEBUG
    private struct ContentViewPreviewHost: View {
        @State private var hasAttemptedBootstrap: Bool
        private let serviceContainer: ServiceContainerProtocol

        fileprivate init(serviceContainer: ServiceContainerProtocol = PreviewServiceContainer()) {
            _hasAttemptedBootstrap = State(initialValue: false)
            self.serviceContainer = serviceContainer
        }

        fileprivate var body: some View {
            ContentView(serviceContainer: serviceContainer)
                .task {
                    await bootstrapDebugDataIfNeeded()
                }
        }

        @MainActor
        private func bootstrapDebugDataIfNeeded() async {
            if Task.isCancelled { return }

            guard hasAttemptedBootstrap == false else {
                return
            }
            hasAttemptedBootstrap = true

            if let debugBootstrapService = serviceContainer.weightEntryService as? WeightEntryDebugBootstrapServiceProtocol {
                do {
                    try await debugBootstrapService.bootstrapIfNeeded()
                } catch {
                    // Ignore bootstrap errors in preview; still render the UI.
                }
            }

            if let debugBootstrapService = serviceContainer.goalService as? GoalDebugBootstrapServiceProtocol {
                do {
                    try await debugBootstrapService.bootstrapIfNeeded()
                } catch {
                    // Ignore bootstrap errors in preview; still render the UI.
                }
            }
        }
    }

    #Preview {
        ContentViewPreviewHost()
    }
#endif
