//
//  PreviewServiceContainer.swift
//  SimpleWeightTracker
//
//  Created by David Thorn on 15.02.2026.
//

#if DEBUG
    import Foundation
    import HealthKit
    import SimpleFramework

    internal struct PreviewServiceContainer: ServiceContainerProtocol {
        internal let weightEntryService: WeightEntryServiceProtocol
        internal let goalService: GoalServiceProtocol
        internal let reminderService: ReminderServiceProtocol
        internal let unitsPreferenceService: UnitsPreferenceServiceProtocol
        internal let historyFilterService: HistoryFilterServiceProtocol
        internal let healthKitWeightService: HealthKitQuantitySyncServiceProtocol
        internal let weightEntrySyncMetadataService: HealthKitEntrySyncMetadataServiceProtocol

        internal init() {
            let previewWeightEntryStore = JSONEntityStore<WeightEntry>(
                fileName: "preview_weight_entries.json",
                sort: { $0.measuredAt > $1.measuredAt }
            )
            let previewGoalStore = JSONValueStore<WeightGoal>(
                fileName: "preview_weight_goal.json"
            )
            let previewSyncMetadataStore = HealthKitEntrySyncMetadataStore(
                fileName: "preview_weight_entry_sync_metadata.json"
            )
            let previewHealthKitQuantityService = HealthKitQuantityService()

            weightEntryService = WeightEntryService(weightEntryStore: previewWeightEntryStore)
            goalService = GoalService(goalStore: previewGoalStore)
            reminderService = ReminderService(
                configuration: ReminderServiceConfiguration(
                    identifierPrefix: "preview.weight.reminder",
                    scheduleEnabledKey: "preview.weight.reminder.schedule.enabled",
                    scheduleStartHourKey: "preview.weight.reminder.schedule.startHour",
                    scheduleEndHourKey: "preview.weight.reminder.schedule.endHour",
                    scheduleIntervalKey: "preview.weight.reminder.schedule.interval",
                    notificationTitle: "Weight Reminder",
                    notificationBody: "Log your weight reading."
                )
            )
            unitsPreferenceService = UnitsPreferenceService(key: "preview_weight_unit_preference")
            historyFilterService = HistoryFilterService(key: "preview_weight_history_filter_configuration")
            healthKitWeightService = HealthKitQuantitySyncService(
                descriptor: HealthKitQuantitySyncDescriptor(
                    quantityIdentifier: .bodyMass,
                    providerIdentifier: "healthkit.bodyMass",
                    autoSyncKey: "preview_weight_healthkit_auto_sync_enabled"
                ),
                quantityService: previewHealthKitQuantityService
            )
            weightEntrySyncMetadataService = HealthKitEntrySyncMetadataService(store: previewSyncMetadataStore)
        }
    }
#endif
