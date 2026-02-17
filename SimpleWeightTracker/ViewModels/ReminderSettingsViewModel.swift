//
//  ReminderSettingsViewModel.swift
//  SimpleWeightTracker
//
//  Created by David Thorn on 15.02.2026.
//

import Combine
import Foundation
import SimpleFramework

@MainActor
internal final class ReminderSettingsViewModel: ObservableObject {
    @Published internal var startHour: Int
    @Published internal var endHour: Int
    @Published internal var intervalMinutes: Int
    @Published internal var isEnabled: Bool
    @Published internal private(set) var initialSchedule: ReminderSchedule?
    @Published internal private(set) var errorMessage: String?

    private let reminderService: ReminderServiceProtocol

    internal init(serviceContainer: ServiceContainerProtocol) {
        reminderService = serviceContainer.reminderService
        startHour = 8
        endHour = 20
        intervalMinutes = 180
        isEnabled = false
        initialSchedule = nil
        errorMessage = nil
    }

    internal var hasChanges: Bool {
        currentSchedule != initialSchedule
    }

    internal var currentSchedule: ReminderSchedule {
        ReminderSchedule(
            startHour: startHour,
            endHour: endHour,
            intervalMinutes: intervalMinutes,
            isEnabled: isEnabled
        )
    }

    internal func load() async {
        let fetched = await reminderService.fetchSchedule()
        initialSchedule = fetched
        if let fetched {
            startHour = fetched.startHour
            endHour = fetched.endHour
            intervalMinutes = fetched.intervalMinutes
            isEnabled = fetched.isEnabled
        }
    }

    internal func save() async -> Bool {
        do {
            try await reminderService.updateSchedule(currentSchedule)
            initialSchedule = currentSchedule
            return true
        } catch {
            errorMessage = error.localizedDescription
            return false
        }
    }

    internal func reset() {
        guard let initialSchedule else { return }
        startHour = initialSchedule.startHour
        endHour = initialSchedule.endHour
        intervalMinutes = initialSchedule.intervalMinutes
        isEnabled = initialSchedule.isEnabled
    }

    internal func deleteSchedule() async -> Bool {
        do {
            try await reminderService.clearSchedule()
            initialSchedule = nil
            isEnabled = false
            return true
        } catch {
            errorMessage = error.localizedDescription
            return false
        }
    }
}
