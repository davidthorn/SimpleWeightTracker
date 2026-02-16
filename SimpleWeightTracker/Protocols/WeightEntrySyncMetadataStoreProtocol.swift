//
//  WeightEntrySyncMetadataStoreProtocol.swift
//  SimpleWeightTracker
//
//  Created by David Thorn on 16.02.2026.
//

import Foundation

internal protocol WeightEntrySyncMetadataStoreProtocol: Sendable {
    func observeMetadata() async throws -> AsyncStream<[WeightEntrySyncMetadata]>
    func fetchMetadata() async throws -> [WeightEntrySyncMetadata]
    func upsertMetadata(_ metadata: WeightEntrySyncMetadata) async throws
    func deleteMetadata(for entryID: WeightEntryIdentifier) async throws
    func deleteAllMetadata() async throws
}
