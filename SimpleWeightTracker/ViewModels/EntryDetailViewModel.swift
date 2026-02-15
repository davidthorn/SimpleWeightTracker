//
//  EntryDetailViewModel.swift
//  SimpleWeightTracker
//
//  Created by David Thorn on 15.02.2026.
//

import Combine
import Foundation

@MainActor
internal final class EntryDetailViewModel: ObservableObject {
    @Published internal private(set) var entry: WeightEntry?
    @Published internal private(set) var errorMessage: String?

    private let entryIdentifier: WeightEntryIdentifier
    private let weightEntryService: WeightEntryServiceProtocol

    internal init(serviceContainer: ServiceContainerProtocol, entryIdentifier: WeightEntryIdentifier) {
        self.entryIdentifier = entryIdentifier
        weightEntryService = serviceContainer.weightEntryService
        entry = nil
        errorMessage = nil
    }

    internal func load() async {
        do {
            let entries = try await weightEntryService.fetchEntries()
            entry = entries.first { $0.id == entryIdentifier.value }
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
