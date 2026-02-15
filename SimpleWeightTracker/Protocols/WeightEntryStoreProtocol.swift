//
//  WeightEntryStoreProtocol.swift
//  SimpleWeightTracker
//
//  Created by David Thorn on 15.02.2026.
//

import Foundation

internal protocol WeightEntryStoreProtocol: Sendable {
    func observeEntries() async throws -> AsyncStream<[WeightEntry]>
    func fetchEntries() async throws -> [WeightEntry]
    func upsertEntry(_ entry: WeightEntry) async throws
    func deleteEntry(id: WeightEntryIdentifier) async throws
}
