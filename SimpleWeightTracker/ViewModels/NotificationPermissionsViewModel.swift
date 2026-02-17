//
//  NotificationPermissionsViewModel.swift
//  SimpleWeightTracker
//
//  Created by David Thorn on 15.02.2026.
//

import Combine
import Foundation
import SimpleFramework
import UIKit

@MainActor
internal final class NotificationPermissionsViewModel: ObservableObject {
    @Published internal private(set) var status: ReminderAuthorizationStatus
    @Published internal private(set) var errorMessage: String?

    private let reminderService: ReminderServiceProtocol

    internal init(serviceContainer: ServiceContainerProtocol) {
        reminderService = serviceContainer.reminderService
        status = .notDetermined
        errorMessage = nil
    }

    internal func load() async {
        status = await reminderService.fetchAuthorizationStatus()
    }

    internal func requestAuthorization() async {
        do {
            status = try await reminderService.requestAuthorization()
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    internal func observeAuthorizationStatusChanges() async {
        let notifications = NotificationCenter.default.notifications(named: UIApplication.didBecomeActiveNotification)
        for await _ in notifications {
            if Task.isCancelled { return }
            status = await reminderService.fetchAuthorizationStatus()
        }
    }
}
