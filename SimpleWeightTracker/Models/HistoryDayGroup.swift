//
//  HistoryDayGroup.swift
//  SimpleWeightTracker
//
//  Created by David Thorn on 15.02.2026.
//

import Foundation

public nonisolated struct HistoryDayGroup: Hashable, Sendable {
    public let day: Date
    public let entries: [WeightEntry]

    public init(day: Date, entries: [WeightEntry]) {
        self.day = day
        self.entries = entries
    }
}
