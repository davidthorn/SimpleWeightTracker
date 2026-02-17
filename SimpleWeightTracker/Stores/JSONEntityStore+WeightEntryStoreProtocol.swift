//
//  JSONEntityStore+WeightEntryStoreProtocol.swift
//  SimpleWeightTracker
//
//  Created by David Thorn on 17.02.2026.
//

import Foundation
import SimpleFramework

extension JSONEntityStore: WeightEntryStoreProtocol where Entity == WeightEntry {
    internal func observeEntries() async throws -> AsyncStream<[WeightEntry]> {
        try await observeEntities()
    }

    internal func fetchEntries() async throws -> [WeightEntry] {
        try await fetchEntities()
    }

    internal func upsertEntry(_ entry: WeightEntry) async throws {
        try await upsertEntity(entry)
    }

    internal func deleteEntry(id: WeightEntryIdentifier) async throws {
        try await deleteEntity(id: id.value)
    }
}
