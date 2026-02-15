//
//  UnitsPreferenceService.swift
//  SimpleWeightTracker
//
//  Created by David Thorn on 15.02.2026.
//

import Foundation

internal struct UnitsPreferenceService: UnitsPreferenceServiceProtocol {
    private static let didChangeNotification = Notification.Name("UnitsPreferenceService.didChange")
    private let key: String

    internal init(key: String = "weight_unit_preference") {
        self.key = key
    }

    internal func observeUnit() async -> AsyncStream<WeightUnit> {
        let streamPair = AsyncStream<WeightUnit>.makeStream()
        let observationTask = Task {
            streamPair.continuation.yield(await fetchUnit())

            let changes = NotificationCenter.default.notifications(named: Self.didChangeNotification)
            for await _ in changes {
                if Task.isCancelled { return }
                streamPair.continuation.yield(await fetchUnit())
            }
        }

        streamPair.continuation.onTermination = { _ in
            observationTask.cancel()
        }

        return streamPair.stream
    }

    internal func fetchUnit() async -> WeightUnit {
        if let rawValue = UserDefaults.standard.string(forKey: key),
           let storedUnit = WeightUnit(rawValue: rawValue) {
            return storedUnit
        }

        return .kilograms
    }

    internal func updateUnit(_ unit: WeightUnit) async {
        UserDefaults.standard.set(unit.rawValue, forKey: key)
        NotificationCenter.default.post(name: Self.didChangeNotification, object: nil)
    }

    internal func resetUnit() async {
        UserDefaults.standard.removeObject(forKey: key)
        NotificationCenter.default.post(name: Self.didChangeNotification, object: nil)
    }
}
