//
//  HomeRoute.swift
//  SimpleWeightTracker
//
//  Created by David Thorn on 15.02.2026.
//

import Foundation

internal enum HomeRoute: Hashable {
    case addEntry
    case editEntry(WeightEntryIdentifier)
    case dayDetail(WeightDayIdentifier)
    case goalSetup
}
