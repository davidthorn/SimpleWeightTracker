//
//  WeightGoal.swift
//  SimpleWeightTracker
//
//  Created by David Thorn on 15.02.2026.
//

import Foundation

/// User-configured target weight.
public nonisolated struct WeightGoal: Codable, Identifiable, Hashable, Sendable {
    /// Stable unique identifier for the goal record.
    public let id: UUID

    /// Desired target weight value.
    public let targetValue: Double

    /// Preferred unit for displaying and editing the goal.
    public let unit: WeightUnit

    /// Timestamp of the last goal update.
    public let updatedAt: Date

    /// Creates a goal record.
    public init(id: UUID, targetValue: Double, unit: WeightUnit, updatedAt: Date) {
        self.id = id
        self.targetValue = targetValue
        self.unit = unit
        self.updatedAt = updatedAt
    }
}
