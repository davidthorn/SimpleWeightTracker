//
//  GoalService+DebugBootstrap.swift
//  SimpleWeightTracker
//
//  Created by David Thorn on 16.02.2026.
//

#if DEBUG
    import Foundation

    extension GoalService: GoalDebugBootstrapServiceProtocol {
        internal func bootstrapIfNeeded() async throws {
            let existingGoal = try await fetchGoal()
            guard existingGoal == nil else {
                return
            }

            let seededGoal = WeightGoal(
                id: UUID(),
                targetValue: 85.0,
                unit: .kilograms,
                updatedAt: Date()
            )

            try await upsertGoal(seededGoal)
        }
    }
#endif
