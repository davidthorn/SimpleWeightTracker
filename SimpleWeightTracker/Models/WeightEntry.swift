//
//  WeightEntry.swift
//  SimpleWeightTracker
//
//  Created by David Thorn on 15.02.2026.
//

import Foundation

/// A single logged weight measurement.
public nonisolated struct WeightEntry: Codable, Identifiable, Hashable, Sendable {
    /// Stable unique identifier for the entry.
    public let id: UUID

    /// Logged weight value in the selected unit at log time.
    public let value: Double

    /// Unit used for the logged value.
    public let unit: WeightUnit

    /// Timestamp for when the weight was measured.
    public let measuredAt: Date

    /// Creates a weight entry record.
    public init(id: UUID, value: Double, unit: WeightUnit, measuredAt: Date) {
        self.id = id
        self.value = value
        self.unit = unit
        self.measuredAt = measuredAt
    }
}
