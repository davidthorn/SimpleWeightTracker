//
//  ReminderAuthorizationStatus.swift
//  SimpleWeightTracker
//
//  Created by David Thorn on 15.02.2026.
//

import Foundation

public nonisolated enum ReminderAuthorizationStatus: String, Codable, Sendable {
    case notDetermined
    case denied
    case authorized
    case provisional
}
