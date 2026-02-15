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

            ProgressScene(serviceContainer: serviceContainer)
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
    #Preview {
        ContentView(serviceContainer: PreviewServiceContainer())
    }
#endif
