//
//  GoalServiceProtocol.swift
//  SimpleWeightTracker
//
//  Created by David Thorn on 15.02.2026.
//

import Foundation

internal protocol GoalServiceProtocol: Sendable {
    func observeGoal() async throws -> AsyncStream<WeightGoal?>
    func fetchGoal() async throws -> WeightGoal?
    func upsertGoal(_ goal: WeightGoal) async throws
    func deleteGoal() async throws
}
