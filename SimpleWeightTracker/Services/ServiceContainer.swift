//
//  ServiceContainer.swift
//  SimpleWeightTracker
//
//  Created by David Thorn on 15.02.2026.
//

import Foundation
import HealthKit
import SimpleFramework

internal struct ServiceContainer: ServiceContainerProtocol {
    internal let weightEntryService: WeightEntryServiceProtocol
    internal let goalService: GoalServiceProtocol
    internal let reminderService: ReminderServiceProtocol
    internal let unitsPreferenceService: UnitsPreferenceServiceProtocol
    internal let historyFilterService: HistoryFilterServiceProtocol
    internal let healthKitWeightService: HealthKitQuantitySyncServiceProtocol
    internal let weightEntrySyncMetadataService: HealthKitEntrySyncMetadataServiceProtocol

    internal init(
        weightEntryStore: WeightEntryStoreProtocol = JSONEntityStore<WeightEntry>(
            fileName: "weight_entries.json",
            sort: { $0.measuredAt > $1.measuredAt }
        ),
        goalStore: GoalStoreProtocol = JSONValueStore<WeightGoal>(fileName: "weight_goal.json"),
        healthKitQuantityService: HealthKitQuantityServiceProtocol = HealthKitQuantityService(),
        weightEntrySyncMetadataStore: HealthKitEntrySyncMetadataStoreProtocol = HealthKitEntrySyncMetadataStore(
            fileName: "weight_entry_sync_metadata.json"
        )
    ) {
        weightEntryService = WeightEntryService(weightEntryStore: weightEntryStore)
        goalService = GoalService(goalStore: goalStore)
        reminderService = ReminderService(
            configuration: ReminderServiceConfiguration(
                identifierPrefix: "weight.reminder",
                scheduleEnabledKey: "weight.reminder.schedule.enabled",
                scheduleStartHourKey: "weight.reminder.schedule.startHour",
                scheduleEndHourKey: "weight.reminder.schedule.endHour",
                scheduleIntervalKey: "weight.reminder.schedule.interval",
                notificationTitle: "Weight Reminder",
                notificationBody: "Log your weight reading."
            )
        )
        unitsPreferenceService = UnitsPreferenceService()
        historyFilterService = HistoryFilterService()
        healthKitWeightService = HealthKitQuantitySyncService(
            descriptor: HealthKitQuantitySyncDescriptor(
                quantityIdentifier: .bodyMass,
                providerIdentifier: "healthkit.bodyMass",
                autoSyncKey: "weight_healthkit_auto_sync_enabled"
            ),
            quantityService: healthKitQuantityService
        )
        weightEntrySyncMetadataService = HealthKitEntrySyncMetadataService(store: weightEntrySyncMetadataStore)
    }
}
