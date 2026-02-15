//
//  WeightEntryService.swift
//  SimpleWeightTracker
//
//  Created by David Thorn on 15.02.2026.
//

import Foundation

internal struct WeightEntryService: WeightEntryServiceProtocol {
    internal let weightEntryStore: WeightEntryStoreProtocol

    internal init(weightEntryStore: WeightEntryStoreProtocol) {
        self.weightEntryStore = weightEntryStore
    }

    internal func observeEntries() async throws -> AsyncStream<[WeightEntry]> {
        try await weightEntryStore.observeEntries()
    }

    internal func fetchEntries() async throws -> [WeightEntry] {
        try await weightEntryStore.fetchEntries()
    }

    internal func upsertEntry(_ entry: WeightEntry) async throws {
        try await weightEntryStore.upsertEntry(entry)
    }

    internal func deleteEntry(id: WeightEntryIdentifier) async throws {
        try await weightEntryStore.deleteEntry(id: id)
    }
}
