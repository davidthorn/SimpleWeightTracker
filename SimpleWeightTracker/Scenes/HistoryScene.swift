//
//  HistoryScene.swift
//  SimpleWeightTracker
//
//  Created by David Thorn on 15.02.2026.
//

import SwiftUI

internal struct HistoryScene: View {
    private let serviceContainer: ServiceContainerProtocol
    @State private var path: [HistoryRoute]

    internal init(serviceContainer: ServiceContainerProtocol) {
        self.serviceContainer = serviceContainer
        _path = State(initialValue: [])
    }

    internal var body: some View {
        NavigationStack(path: $path) {
            HistoryView(serviceContainer: serviceContainer)
                .navigationDestination(for: HistoryRoute.self) { route in
                    switch route {
                    case .addEntry:
                        AddWeightEntryView(serviceContainer: serviceContainer)
                    case .dayDetail(let dayIdentifier):
                        DayDetailView(serviceContainer: serviceContainer, dayIdentifier: dayIdentifier)
                    case .entryDetail(let entryIdentifier):
                        EntryDetailView(serviceContainer: serviceContainer, entryIdentifier: entryIdentifier)
                    case .filter:
                        HistoryFilterView()
                    }
                }
        }
    }
}

#if DEBUG
    #Preview {
        HistoryScene(serviceContainer: PreviewServiceContainer())
    }
#endif
