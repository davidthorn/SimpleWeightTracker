//
//  ChartWindow.swift
//  SimpleWeightTracker
//
//  Created by David Thorn on 16.02.2026.
//

import Foundation

public nonisolated enum ChartWindow: String, CaseIterable, Sendable {
    case last7Days
    case last30Days
    case all

    public var title: String {
        switch self {
        case .last7Days:
            return "7 Day Trend"
        case .last30Days:
            return "30 Day Trend"
        case .all:
            return "All Time Trend"
        }
    }

    public var dayCount: Int? {
        switch self {
        case .last7Days:
            return 7
        case .last30Days:
            return 30
        case .all:
            return nil
        }
    }
}
