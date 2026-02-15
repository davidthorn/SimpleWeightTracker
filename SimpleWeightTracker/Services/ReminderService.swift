//
//  ReminderService.swift
//  SimpleWeightTracker
//
//  Created by David Thorn on 15.02.2026.
//

import Foundation
import UserNotifications

internal struct ReminderService: ReminderServiceProtocol {
    private let scheduleKey: String

    internal init(scheduleKey: String = "weight_reminder_schedule") {
        self.scheduleKey = scheduleKey
    }

    internal func observeAuthorizationStatus() async -> AsyncStream<ReminderAuthorizationStatus> {
        let streamPair = AsyncStream<ReminderAuthorizationStatus>.makeStream()
        streamPair.continuation.yield(await fetchAuthorizationStatus())
        return streamPair.stream
    }

    internal func observeSchedule() async -> AsyncStream<ReminderSchedule?> {
        let streamPair = AsyncStream<ReminderSchedule?>.makeStream()
        streamPair.continuation.yield(await fetchSchedule())
        return streamPair.stream
    }

    internal func fetchAuthorizationStatus() async -> ReminderAuthorizationStatus {
        let settings = await UNUserNotificationCenter.current().notificationSettings()
        switch settings.authorizationStatus {
        case .notDetermined:
            return .notDetermined
        case .denied:
            return .denied
        case .authorized:
            return .authorized
        case .provisional:
            return .provisional
        case .ephemeral:
            return .authorized
        @unknown default:
            return .notDetermined
        }
    }

    internal func fetchSchedule() async -> ReminderSchedule? {
        guard let data = UserDefaults.standard.data(forKey: scheduleKey) else {
            return nil
        }

        let decoder = JSONDecoder()
        return try? decoder.decode(ReminderSchedule.self, from: data)
    }

    internal func requestAuthorization() async throws -> ReminderAuthorizationStatus {
        _ = try await UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge])
        return await fetchAuthorizationStatus()
    }

    internal func updateSchedule(_ schedule: ReminderSchedule?) async throws {
        if let schedule {
            let encoder = JSONEncoder()
            let data = try encoder.encode(schedule)
            UserDefaults.standard.set(data, forKey: scheduleKey)
        } else {
            UserDefaults.standard.removeObject(forKey: scheduleKey)
        }
    }

    internal func clearSchedule() async throws {
        UserDefaults.standard.removeObject(forKey: scheduleKey)
    }
}
