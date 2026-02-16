//
//  HealthKitAuthorizationState.swift
//  SimpleWeightTracker
//
//  Created by David Thorn on 16.02.2026.
//

import Foundation

public nonisolated enum HealthKitAuthorizationState: String, Codable, Sendable {
    case unavailable
    case notDetermined
    case authorized
    case denied

    public var displayText: String {
        switch self {
        case .unavailable:
            return "Unavailable"
        case .notDetermined:
            return "Not requested"
        case .authorized:
            return "Authorized"
        case .denied:
            return "Denied"
        }
    }
}
