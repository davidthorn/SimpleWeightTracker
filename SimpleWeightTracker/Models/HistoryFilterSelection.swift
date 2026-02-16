//
//  HistoryFilterSelection.swift
//  SimpleWeightTracker
//
//  Created by David Thorn on 15.02.2026.
//

import Foundation

public nonisolated enum HistoryFilterSelection: String, CaseIterable, Codable, Sendable {
    case last7Days
    case last30Days
    case custom
}
