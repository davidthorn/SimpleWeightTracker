//
//  ServiceContainerProtocol.swift
//  SimpleWeightTracker
//
//  Created by David Thorn on 15.02.2026.
//

import Foundation

internal protocol ServiceContainerProtocol: Sendable {
    var weightEntryService: WeightEntryServiceProtocol { get }
    var goalService: GoalServiceProtocol { get }
    var reminderService: ReminderServiceProtocol { get }
    var unitsPreferenceService: UnitsPreferenceServiceProtocol { get }
    var historyFilterService: HistoryFilterServiceProtocol { get }
}
