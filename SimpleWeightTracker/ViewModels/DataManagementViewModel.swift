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

    private let goalService: GoalServiceProtocol
    private let unitsPreferenceService: UnitsPreferenceServiceProtocol
    private let reminderService: ReminderServiceProtocol

    internal init(serviceContainer: ServiceContainerProtocol) {
        goalService = serviceContainer.goalService
        unitsPreferenceService = serviceContainer.unitsPreferenceService
        reminderService = serviceContainer.reminderService
        message = nil
    }

    internal func resetPreferences() async {
        await unitsPreferenceService.resetUnit()
        try? await reminderService.clearSchedule()
        message = "Preferences reset"
    }

    internal func clearGoal() async {
        try? await goalService.deleteGoal()
        message = "Goal deleted"
    }
}
