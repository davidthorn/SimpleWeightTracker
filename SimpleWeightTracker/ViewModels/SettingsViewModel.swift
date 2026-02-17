//
//  SettingsViewModel.swift
//  SimpleWeightTracker
//
//  Created by David Thorn on 15.02.2026.
//

import Combine
import Foundation
import SimpleFramework

@MainActor
internal final class SettingsViewModel: ObservableObject {
    @Published internal private(set) var unit: WeightUnit
    @Published internal private(set) var reminderStatus: ReminderAuthorizationStatus
    @Published internal private(set) var healthKitPermissionState: HealthKitPermissionState

    private let unitsPreferenceService: UnitsPreferenceServiceProtocol
    private let reminderService: ReminderServiceProtocol
    private let healthKitWeightService: HealthKitQuantitySyncServiceProtocol

    internal init(serviceContainer: ServiceContainerProtocol) {
        unitsPreferenceService = serviceContainer.unitsPreferenceService
        reminderService = serviceContainer.reminderService
        healthKitWeightService = serviceContainer.healthKitWeightService
        unit = .kilograms
        reminderStatus = .notDetermined
        healthKitPermissionState = .unavailable()
    }

    internal func load() async {
        unit = await unitsPreferenceService.fetchUnit()
        reminderStatus = await reminderService.fetchAuthorizationStatus()
        healthKitPermissionState = await healthKitWeightService.fetchPermissionState()
    }

    internal func observeUnit() async {
        let stream = await unitsPreferenceService.observeUnit()
        for await snapshot in stream {
            unit = snapshot
        }
    }

    internal var healthKitSubtitle: String {
        "Read: \(healthKitPermissionState.read.displayText) • Write: \(healthKitPermissionState.write.displayText)"
    }
}
