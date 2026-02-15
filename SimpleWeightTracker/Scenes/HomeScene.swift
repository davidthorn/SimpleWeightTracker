//
//  HomeScene.swift
//  SimpleWeightTracker
//
//  Created by David Thorn on 15.02.2026.
//

import SwiftUI

internal struct HomeScene: View {
    private let serviceContainer: ServiceContainerProtocol
    @State private var path: [HomeRoute]

    internal init(serviceContainer: ServiceContainerProtocol) {
        self.serviceContainer = serviceContainer
        _path = State(initialValue: [])
    }

    internal var body: some View {
        NavigationStack(path: $path) {
            HomeView(serviceContainer: serviceContainer)
                .navigationDestination(for: HomeRoute.self) { route in
                    switch route {
                    case .addEntry:
                        AddWeightEntryView(serviceContainer: serviceContainer)
                    case .editEntry(let identifier):
                        EditWeightEntryView(serviceContainer: serviceContainer, entryIdentifier: identifier)
                    case .dayDetail(let dayIdentifier):
                        DayDetailView(serviceContainer: serviceContainer, dayIdentifier: dayIdentifier)
                    case .goalSetup:
                        GoalSetupView(serviceContainer: serviceContainer)
                    }
                }
        }
    }
}

#if DEBUG
    #Preview {
        HomeScene(serviceContainer: PreviewServiceContainer())
    }
#endif
