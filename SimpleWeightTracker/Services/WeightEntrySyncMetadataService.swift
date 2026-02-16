//
//  WeightEntrySyncMetadataService.swift
//  SimpleWeightTracker
//
//  Created by David Thorn on 16.02.2026.
//

import Foundation

internal struct WeightEntrySyncMetadataService: WeightEntrySyncMetadataServiceProtocol {
    private let store: WeightEntrySyncMetadataStoreProtocol

    internal init(store: WeightEntrySyncMetadataStoreProtocol) {
        self.store = store
    }

    internal func observeMetadata() async throws -> AsyncStream<[WeightEntrySyncMetadata]> {
        try await store.observeMetadata()
    }

    internal func fetchMetadata() async throws -> [WeightEntrySyncMetadata] {
        try await store.fetchMetadata()
    }

    internal func fetchMetadata(for entryID: WeightEntryIdentifier, providerIdentifier: String) async throws -> WeightEntrySyncMetadata? {
        let metadata = try await store.fetchMetadata()
        return metadata.first {
            $0.entryID == entryID.value && $0.providerIdentifier == providerIdentifier
        }
    }

    internal func upsertMetadata(_ metadata: WeightEntrySyncMetadata) async throws {
        try await store.upsertMetadata(metadata)
    }

    internal func deleteMetadata(for entryID: WeightEntryIdentifier) async throws {
        try await store.deleteMetadata(for: entryID)
    }

    internal func deleteAllMetadata() async throws {
        try await store.deleteAllMetadata()
    }
}
