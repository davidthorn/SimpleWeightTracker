//
//  DayDetailViewModel.swift
//  SimpleWeightTracker
//
//  Created by David Thorn on 15.02.2026.
//

import Combine
import Foundation

@MainActor
internal final class DayDetailViewModel: ObservableObject {
    @Published internal private(set) var entries: [WeightEntry]
    @Published internal private(set) var goal: WeightGoal?
    @Published internal private(set) var errorMessage: String?

    private let day: Date
    private let weightEntryService: WeightEntryServiceProtocol
    private let goalService: GoalServiceProtocol

    internal init(serviceContainer: ServiceContainerProtocol, day: Date) {
        self.day = day
        weightEntryService = serviceContainer.weightEntryService
        goalService = serviceContainer.goalService
        entries = []
        goal = nil
        errorMessage = nil
    }

    internal var titleText: String {
        day.formatted(date: .abbreviated, time: .omitted)
    }

    internal var subtitleText: String {
        day.formatted(date: .complete, time: .omitted)
    }

    internal var entryCount: Int {
        entries.count
    }

    internal var firstEntryTimeText: String {
        guard let firstEntry = entries.min(by: { $0.measuredAt < $1.measuredAt }) else {
            return "-"
        }
        return firstEntry.measuredAt.formatted(date: .omitted, time: .shortened)
    }

    internal var lastEntryTimeText: String {
        guard let lastEntry = entries.max(by: { $0.measuredAt < $1.measuredAt }) else {
            return "-"
        }
        return lastEntry.measuredAt.formatted(date: .omitted, time: .shortened)
    }

    internal var metricUnitText: String? {
        guard let firstUnit = entries.first?.unit else {
            return nil
        }
        let isSingleUnit = entries.allSatisfy { $0.unit == firstUnit }
        guard isSingleUnit else {
            return nil
        }
        return firstUnit == .kilograms ? "kg" : "lb"
    }

    internal var minimumValueText: String {
        guard
            let minimumValue = entries.map(\.value).min(),
            let metricUnitText
        else {
            return "-"
        }
        return String(format: "%.1f %@", minimumValue, metricUnitText)
    }

    internal var maximumValueText: String {
        guard
            let maximumValue = entries.map(\.value).max(),
            let metricUnitText
        else {
            return "-"
        }
        return String(format: "%.1f %@", maximumValue, metricUnitText)
    }

    internal var averageValueText: String {
        guard
            entries.isEmpty == false,
            let metricUnitText
        else {
            return "-"
        }
        let total = entries.reduce(0.0) { partialResult, entry in
            partialResult + entry.value
        }
        let average = total / Double(entries.count)
        return String(format: "%.1f %@", average, metricUnitText)
    }

    internal var goalTargetValue: Double? {
        guard
            let goal,
            let firstUnit = entries.first?.unit,
            goal.unit == firstUnit
        else {
            return nil
        }
        return goal.targetValue
    }

    internal var goalTargetUnit: WeightUnit? {
        guard goalTargetValue != nil else {
            return nil
        }
        return entries.first?.unit
    }

    internal var goalFeedbackText: String {
        guard
            let latestEntry = entries.max(by: { $0.measuredAt < $1.measuredAt }),
            let goal,
            goal.unit == latestEntry.unit
        else {
            return "Set a target in matching units for progress feedback."
        }

        let delta = latestEntry.value - goal.targetValue
        let absDelta = abs(delta)
        let unitText = latestEntry.unit == .kilograms ? "kg" : "lb"

        if absDelta < 0.05 {
            return "Latest entry is right on target."
        }

        if delta > 0 {
            return String(format: "%.1f %@ above target", absDelta, unitText)
        }

        return String(format: "%.1f %@ below target", absDelta, unitText)
    }

    internal func load() async {
        do {
            async let fetchedEntries = weightEntryService.fetchEntries()
            async let fetchedGoal = goalService.fetchGoal()
            let allEntries = try await fetchedEntries
            goal = try await fetchedGoal
            let calendar = Calendar.current
            entries = allEntries
                .filter { calendar.isDate($0.measuredAt, inSameDayAs: day) }
                .sorted { $0.measuredAt > $1.measuredAt }
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
