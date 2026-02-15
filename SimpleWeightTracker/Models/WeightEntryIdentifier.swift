//
//  WeightEntryIdentifier.swift
//  SimpleWeightTracker
//
//  Created by David Thorn on 15.02.2026.
//

import Foundation

/// Shared identifier payload for weight entry lookup and navigation.
public nonisolated struct WeightEntryIdentifier: Codable, Hashable, Sendable {
    /// Backing entry identifier value.
    public let value: UUID

    /// Creates an entry identifier payload.
    public init(value: UUID) {
        self.value = value
    }
}
