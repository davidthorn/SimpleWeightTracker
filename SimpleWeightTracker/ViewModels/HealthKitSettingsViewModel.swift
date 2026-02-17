//
//  HealthKitSettingsViewModel.swift
//  SimpleWeightTracker
//
//  Created by David Thorn on 16.02.2026.
//

import Combine
import Foundation
import SimpleFramework
import UIKit

@MainActor
internal final class HealthKitSettingsViewModel: ObservableObject {
    @Published internal private(set) var isHealthKitAvailable: Bool
    @Published internal private(set) var permissionState: HealthKitPermissionState
    @Published internal private(set) var isAutoSyncEnabled: Bool
    @Published internal private(set) var errorMessage: String?

    private let healthKitWeightService: HealthKitQuantitySyncServiceProtocol

    internal init(serviceContainer: ServiceContainerProtocol) {
        healthKitWeightService = serviceContainer.healthKitWeightService
        isHealthKitAvailable = false
        permissionState = .unavailable()
        isAutoSyncEnabled = false
        errorMessage = nil
    }

    internal func load() async {
        isHealthKitAvailable = await healthKitWeightService.isAvailable()
        permissionState = await healthKitWeightService.fetchPermissionState()
        isAutoSyncEnabled = await healthKitWeightService.fetchAutoSyncEnabled()
    }

    internal func observeAutoSync() async {
        let stream = await healthKitWeightService.observeAutoSyncEnabled()
        for await snapshot in stream {
            isAutoSyncEnabled = snapshot
        }
    }

    internal func observeAppDidBecomeActive() async {
        let notifications = NotificationCenter.default.notifications(named: UIApplication.didBecomeActiveNotification)
        for await _ in notifications {
            if Task.isCancelled { return }
            permissionState = await healthKitWeightService.fetchPermissionState()
        }
    }

    internal func requestPermissions() async {
        permissionState = await healthKitWeightService.requestPermissions()
    }

    internal func setAutoSyncEnabled(_ isEnabled: Bool) async {
        await healthKitWeightService.updateAutoSyncEnabled(isEnabled)
        isAutoSyncEnabled = isEnabled

        if isEnabled && permissionState.write != .authorized {
            permissionState = await healthKitWeightService.requestPermissions()
            if permissionState.write != .authorized {
                errorMessage = "Enable Health permissions to save weight entries into HealthKit."
            } else {
                errorMessage = nil
            }
        } else {
            errorMessage = nil
        }
    }

    internal var statusSummaryText: String {
        if isHealthKitAvailable == false {
            return "Health data is unavailable on this device."
        }

        if permissionState.read == .authorized && permissionState.write == .authorized {
            return "Read and write are authorized for body weight."
        }

        if permissionState.read == .denied || permissionState.write == .denied {
            return "At least one permission is denied. Open Settings to update access."
        }

        return "Grant access to keep your weight entries synced with HealthKit."
    }
}
