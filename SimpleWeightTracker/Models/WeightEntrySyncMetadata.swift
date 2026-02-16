//
//  WeightEntrySyncMetadata.swift
//  SimpleWeightTracker
//
//  Created by David Thorn on 16.02.2026.
//

import Foundation

public nonisolated struct WeightEntrySyncMetadata: Codable, Identifiable, Hashable, Sendable {
    public let id: UUID
    public let entryID: UUID
    public let providerIdentifier: String
    public let externalIdentifier: String
    public let syncedAt: Date

    public init(
        id: UUID = UUID(),
        entryID: UUID,
        providerIdentifier: String,
        externalIdentifier: String,
        syncedAt: Date
    ) {
        self.id = id
        self.entryID = entryID
        self.providerIdentifier = providerIdentifier
        self.externalIdentifier = externalIdentifier
        self.syncedAt = syncedAt
    }
}
