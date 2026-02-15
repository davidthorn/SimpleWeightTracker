//
//  WeightEntryDebugBootstrapServiceProtocol.swift
//  SimpleWeightTracker
//
//  Created by David Thorn on 15.02.2026.
//

#if DEBUG
    import Foundation

    internal protocol WeightEntryDebugBootstrapServiceProtocol: Sendable {
        func bootstrapIfNeeded() async throws
    }
#endif
