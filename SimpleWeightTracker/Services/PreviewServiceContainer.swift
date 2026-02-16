//
//  PreviewServiceContainer.swift
//  SimpleWeightTracker
//
//  Created by David Thorn on 15.02.2026.
//

#if DEBUG
    import Foundation

    internal struct PreviewServiceContainer: ServiceContainerProtocol {
        internal let weightEntryService: WeightEntryServiceProtocol
        internal let goalService: GoalServiceProtocol
        internal let reminderService: ReminderServiceProtocol
        internal let unitsPreferenceService: UnitsPreferenceServiceProtocol
        internal let historyFilterService: HistoryFilterServiceProtocol
        internal let healthKitWeightService: HealthKitWeightServiceProtocol
        internal let weightEntrySyncMetadataService: WeightEntrySyncMetadataServiceProtocol

        internal init() {
            let previewFilePathResolver = StoreFilePathResolver()
            let previewCodec = StoreJSONCodec()

            let previewWeightEntryStore = WeightEntryStore(
                fileName: "preview_weight_entries.json",
                filePathResolver: previewFilePathResolver,
                codec: previewCodec
            )
            let previewGoalStore = GoalStore(
                fileName: "preview_weight_goal.json",
                filePathResolver: previewFilePathResolver,
                codec: previewCodec
            )
            let previewSyncMetadataStore = WeightEntrySyncMetadataStore(
                fileName: "preview_weight_entry_sync_metadata.json",
                filePathResolver: previewFilePathResolver,
                codec: previewCodec
            )

            weightEntryService = WeightEntryService(weightEntryStore: previewWeightEntryStore)
            goalService = GoalService(goalStore: previewGoalStore)
            reminderService = ReminderService(scheduleKey: "preview_weight_reminder_schedule")
            unitsPreferenceService = UnitsPreferenceService(key: "preview_weight_unit_preference")
            historyFilterService = HistoryFilterService(key: "preview_weight_history_filter_configuration")
            healthKitWeightService = HealthKitWeightService(autoSyncKey: "preview_weight_healthkit_auto_sync_enabled")
            weightEntrySyncMetadataService = WeightEntrySyncMetadataService(store: previewSyncMetadataStore)
        }
    }
#endif
