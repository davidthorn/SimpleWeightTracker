//
//  HistoryRoute.swift
//  SimpleWeightTracker
//
//  Created by David Thorn on 15.02.2026.
//

import Foundation

internal enum HistoryRoute: Hashable {
    case addEntry
    case dayDetail(WeightDayIdentifier)
    case entryDetail(WeightEntryIdentifier)
    case filter
}
