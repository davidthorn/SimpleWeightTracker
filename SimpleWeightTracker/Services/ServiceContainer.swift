//
//  ServiceContainer.swift
//  SimpleWeightTracker
//
//  Created by David Thorn on 15.02.2026.
//

import Foundation

internal struct ServiceContainer: ServiceContainerProtocol {
    internal let weightEntryService: WeightEntryServiceProtocol
    internal let goalService: GoalServiceProtocol
    internal let reminderService: ReminderServiceProtocol
    internal let unitsPreferenceService: UnitsPreferenceServiceProtocol
    internal let historyFilterService: HistoryFilterServiceProtocol
    internal let healthKitWeightService: HealthKitWeightServiceProtocol
    internal let weightEntrySyncMetadataService: WeightEntrySyncMetadataServiceProtocol

    internal init(
        weightEntryStore: WeightEntryStoreProtocol = WeightEntryStore(),
        goalStore: GoalStoreProtocol = GoalStore(),
        weightEntrySyncMetadataStore: WeightEntrySyncMetadataStoreProtocol = WeightEntrySyncMetadataStore()
    ) {
        weightEntryService = WeightEntryService(weightEntryStore: weightEntryStore)
        goalService = GoalService(goalStore: goalStore)
        reminderService = ReminderService()
        unitsPreferenceService = UnitsPreferenceService()
        historyFilterService = HistoryFilterService()
        healthKitWeightService = HealthKitWeightService()
        weightEntrySyncMetadataService = WeightEntrySyncMetadataService(store: weightEntrySyncMetadataStore)
    }
}
