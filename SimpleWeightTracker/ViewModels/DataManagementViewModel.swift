//
//  DataManagementViewModel.swift
//  SimpleWeightTracker
//
//  Created by David Thorn on 15.02.2026.
//

import Combine
import Foundation

@MainActor
internal final class DataManagementViewModel: ObservableObject {
    @Published internal private(set) var message: String?
    @Published internal private(set) var isErrorMessage: Bool
    @Published internal private(set) var isPerformingAction: Bool

    private let weightEntryService: WeightEntryServiceProtocol
    private let goalService: GoalServiceProtocol
    private let unitsPreferenceService: UnitsPreferenceServiceProtocol
    private let reminderService: ReminderServiceProtocol
    private let historyFilterService: HistoryFilterServiceProtocol

    internal init(serviceContainer: ServiceContainerProtocol) {
        weightEntryService = serviceContainer.weightEntryService
        goalService = serviceContainer.goalService
        unitsPreferenceService = serviceContainer.unitsPreferenceService
        reminderService = serviceContainer.reminderService
        historyFilterService = serviceContainer.historyFilterService
        message = nil
        isErrorMessage = false
        isPerformingAction = false
    }

    internal func resetPreferences() async {
        isPerformingAction = true
        defer { isPerformingAction = false }

        await unitsPreferenceService.resetUnit()
        await historyFilterService.resetConfiguration()
        try? await reminderService.clearSchedule()
        isErrorMessage = false
        message = "Preferences reset."
    }

    internal func clearGoal() async {
        isPerformingAction = true
        defer { isPerformingAction = false }

        do {
            try await goalService.deleteGoal()
            isErrorMessage = false
            message = "Goal deleted."
        } catch {
            isErrorMessage = true
            message = "Unable to delete goal: \(error.localizedDescription)"
        }
    }

    internal func wipeAllData() async {
        isPerformingAction = true
        defer { isPerformingAction = false }

        do {
            let entries = try await weightEntryService.fetchEntries()
            for entry in entries {
                if Task.isCancelled { return }
                try await weightEntryService.deleteEntry(id: WeightEntryIdentifier(value: entry.id))
            }

            try await goalService.deleteGoal()
            await unitsPreferenceService.resetUnit()
            await historyFilterService.resetConfiguration()
            try await reminderService.clearSchedule()

            isErrorMessage = false
            message = "All data wiped."
        } catch {
            isErrorMessage = true
            message = "Unable to wipe all data: \(error.localizedDescription)"
        }
    }
}
