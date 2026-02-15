//
//  ReminderSchedule.swift
//  SimpleWeightTracker
//
//  Created by David Thorn on 15.02.2026.
//

import Foundation

public nonisolated struct ReminderSchedule: Codable, Hashable, Sendable {
    public let startHour: Int
    public let endHour: Int
    public let intervalMinutes: Int
    public let isEnabled: Bool

    public init(startHour: Int, endHour: Int, intervalMinutes: Int, isEnabled: Bool) {
        self.startHour = startHour
        self.endHour = endHour
        self.intervalMinutes = intervalMinutes
        self.isEnabled = isEnabled
    }
}
