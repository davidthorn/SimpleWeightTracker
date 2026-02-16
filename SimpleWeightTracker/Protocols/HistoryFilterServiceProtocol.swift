//
//  HistoryFilterServiceProtocol.swift
//  SimpleWeightTracker
//
//  Created by David Thorn on 16.02.2026.
//

import Foundation

internal protocol HistoryFilterServiceProtocol: Sendable {
    func observeConfiguration() async -> AsyncStream<HistoryFilterConfiguration>
    func fetchConfiguration() async -> HistoryFilterConfiguration
    func updateConfiguration(_ configuration: HistoryFilterConfiguration) async
    func resetConfiguration() async
}
