//
//  HealthKitWeightServiceProtocol.swift
//  SimpleWeightTracker
//
//  Created by David Thorn on 16.02.2026.
//

import Foundation

internal protocol HealthKitWeightServiceProtocol: Sendable {
    var providerIdentifier: String { get }
    func isAvailable() async -> Bool
    func observeAutoSyncEnabled() async -> AsyncStream<Bool>
    func fetchAutoSyncEnabled() async -> Bool
    func updateAutoSyncEnabled(_ isEnabled: Bool) async
    func resetAutoSyncEnabled() async

    func fetchPermissionState() async -> HealthKitWeightPermissionState
    func requestWeightPermissions() async -> HealthKitWeightPermissionState

    func syncEntryIfEnabled(_ entry: WeightEntry) async throws -> String?
    func syncEntry(_ entry: WeightEntry) async throws -> String
}
