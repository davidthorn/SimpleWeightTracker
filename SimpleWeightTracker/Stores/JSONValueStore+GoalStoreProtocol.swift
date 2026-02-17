//
//  JSONValueStore+GoalStoreProtocol.swift
//  SimpleWeightTracker
//
//  Created by David Thorn on 17.02.2026.
//

import Foundation
import SimpleFramework

extension JSONValueStore: GoalStoreProtocol where Value == WeightGoal {
    internal func observeGoal() async throws -> AsyncStream<WeightGoal?> {
        try await observeValue()
    }

    internal func fetchGoal() async throws -> WeightGoal? {
        try await fetchValue()
    }

    internal func upsertGoal(_ goal: WeightGoal) async throws {
        try await upsertValue(goal)
    }

    internal func deleteGoal() async throws {
        try await deleteValue()
    }
}
