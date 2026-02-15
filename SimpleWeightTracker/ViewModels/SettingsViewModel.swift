//
//  SettingsViewModel.swift
//  SimpleWeightTracker
//
//  Created by David Thorn on 15.02.2026.
//

import Combine
import Foundation

@MainActor
internal final class SettingsViewModel: ObservableObject {
    @Published internal private(set) var unit: WeightUnit
    @Published internal private(set) var reminderStatus: ReminderAuthorizationStatus

    private let unitsPreferenceService: UnitsPreferenceServiceProtocol
    private let reminderService: ReminderServiceProtocol

    internal init(serviceContainer: ServiceContainerProtocol) {
        unitsPreferenceService = serviceContainer.unitsPreferenceService
        reminderService = serviceContainer.reminderService
        unit = .kilograms
        reminderStatus = .notDetermined
    }

    internal func load() async {
        unit = await unitsPreferenceService.fetchUnit()
        reminderStatus = await reminderService.fetchAuthorizationStatus()
    }

    internal func observeUnit() async {
        let stream = await unitsPreferenceService.observeUnit()
        for await snapshot in stream {
            unit = snapshot
        }
    }
}
