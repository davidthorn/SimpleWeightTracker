//
//  HealthKitWeightPermissionState.swift
//  SimpleWeightTracker
//
//  Created by David Thorn on 16.02.2026.
//

import Foundation

public nonisolated struct HealthKitWeightPermissionState: Codable, Hashable, Sendable {
    public let read: HealthKitAuthorizationState
    public let write: HealthKitAuthorizationState

    public init(read: HealthKitAuthorizationState, write: HealthKitAuthorizationState) {
        self.read = read
        self.write = write
    }

    public static func unavailable() -> HealthKitWeightPermissionState {
        HealthKitWeightPermissionState(read: .unavailable, write: .unavailable)
    }
}
