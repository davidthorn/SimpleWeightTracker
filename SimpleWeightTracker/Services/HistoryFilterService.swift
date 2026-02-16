//
//  HistoryFilterService.swift
//  SimpleWeightTracker
//
//  Created by David Thorn on 16.02.2026.
//

import Foundation

internal struct HistoryFilterService: HistoryFilterServiceProtocol {
    private static let didChangeNotification = Notification.Name("HistoryFilterService.didChange")
    private let key: String
    private let encoder: JSONEncoder
    private let decoder: JSONDecoder

    internal init(key: String = "weight_history_filter_configuration") {
        self.key = key
        encoder = JSONEncoder()
        decoder = JSONDecoder()
    }

    internal func observeConfiguration() async -> AsyncStream<HistoryFilterConfiguration> {
        let streamPair = AsyncStream<HistoryFilterConfiguration>.makeStream()
        let observationTask = Task {
            streamPair.continuation.yield(await fetchConfiguration())

            let changes = NotificationCenter.default.notifications(named: Self.didChangeNotification)
            for await _ in changes {
                if Task.isCancelled { return }
                streamPair.continuation.yield(await fetchConfiguration())
            }
        }

        streamPair.continuation.onTermination = { _ in
            observationTask.cancel()
        }

        return streamPair.stream
    }

    internal func fetchConfiguration() async -> HistoryFilterConfiguration {
        guard let data = UserDefaults.standard.data(forKey: key) else {
            return HistoryFilterConfiguration.defaultValue()
        }

        do {
            return try decoder.decode(HistoryFilterConfiguration.self, from: data)
        } catch {
            return HistoryFilterConfiguration.defaultValue()
        }
    }

    internal func updateConfiguration(_ configuration: HistoryFilterConfiguration) async {
        if let data = try? encoder.encode(configuration) {
            UserDefaults.standard.set(data, forKey: key)
        }

        NotificationCenter.default.post(name: Self.didChangeNotification, object: nil)
    }

    internal func resetConfiguration() async {
        UserDefaults.standard.removeObject(forKey: key)
        NotificationCenter.default.post(name: Self.didChangeNotification, object: nil)
    }
}
