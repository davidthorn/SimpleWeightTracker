//
//  HistoryScene.swift
//  SimpleWeightTracker
//
//  Created by David Thorn on 15.02.2026.
//

import SwiftUI

internal struct HistoryScene: View {
    private let serviceContainer: ServiceContainerProtocol

    internal init(serviceContainer: ServiceContainerProtocol) {
        self.serviceContainer = serviceContainer
    }

    internal var body: some View {
        NavigationStack {
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
                        HistoryFilterView(serviceContainer: serviceContainer)
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
