//
//  GoalDebugBootstrapServiceProtocol.swift
//  SimpleWeightTracker
//
//  Created by David Thorn on 16.02.2026.
//

#if DEBUG
    import Foundation

    internal protocol GoalDebugBootstrapServiceProtocol: Sendable {
        func bootstrapIfNeeded() async throws
    }
#endif
