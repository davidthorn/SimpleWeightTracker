//
//  EntryDetailView.swift
//  SimpleWeightTracker
//
//  Created by David Thorn on 15.02.2026.
//

import SwiftUI

internal struct EntryDetailView: View {
    private let serviceContainer: ServiceContainerProtocol
    private let entryIdentifier: WeightEntryIdentifier

    internal init(serviceContainer: ServiceContainerProtocol, entryIdentifier: WeightEntryIdentifier) {
        self.serviceContainer = serviceContainer
        self.entryIdentifier = entryIdentifier
    }

    internal var body: some View {
        EditWeightEntryView(serviceContainer: serviceContainer, entryIdentifier: entryIdentifier)
    }
}

#if DEBUG
    #Preview {
        NavigationStack {
            EntryDetailView(serviceContainer: PreviewServiceContainer(), entryIdentifier: WeightEntryIdentifier(value: UUID()))
        }
    }
#endif
