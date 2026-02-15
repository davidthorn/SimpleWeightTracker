//
//  ProgressViewModel.swift
//  SimpleWeightTracker
//
//  Created by David Thorn on 15.02.2026.
//

import Combine
import Foundation

@MainActor
internal final class ProgressViewModel: ObservableObject {
    @Published internal private(set) var entries: [WeightEntry]
    @Published internal private(set) var goal: WeightGoal?
    @Published internal private(set) var errorMessage: String?

    private let weightEntryService: WeightEntryServiceProtocol
    private let goalService: GoalServiceProtocol
    private let unitsPreferenceService: UnitsPreferenceServiceProtocol
    private var sourceEntries: [WeightEntry]
    private var preferredUnit: WeightUnit

    internal init(serviceContainer: ServiceContainerProtocol) {
        weightEntryService = serviceContainer.weightEntryService
        goalService = serviceContainer.goalService
        unitsPreferenceService = serviceContainer.unitsPreferenceService
        entries = []
        goal = nil
        errorMessage = nil
        sourceEntries = []
        preferredUnit = .kilograms
    }

    internal func load() async {
        do {
            async let fetchedEntries = weightEntryService.fetchEntries()
            async let fetchedGoal = goalService.fetchGoal()
            async let fetchedUnit = unitsPreferenceService.fetchUnit()

            sourceEntries = try await fetchedEntries.sorted { $0.measuredAt > $1.measuredAt }
            goal = try await fetchedGoal
            preferredUnit = await fetchedUnit
            applyPreferredUnitProjection()
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    internal func observeEntries() async {
        do {
            let stream = try await weightEntryService.observeEntries()
            for await snapshot in stream {
                sourceEntries = snapshot.sorted { $0.measuredAt > $1.measuredAt }
                applyPreferredUnitProjection()
            }
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    internal func observeGoal() async {
        do {
            let stream = try await goalService.observeGoal()
            for await snapshot in stream {
                goal = snapshot
            }
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    internal func observeUnit() async {
        let stream = await unitsPreferenceService.observeUnit()
        for await snapshot in stream {
            preferredUnit = snapshot
            applyPreferredUnitProjection()
        }
    }

    internal func summary(days: Int) -> ProgressSummary? {
        let cutoffDate = Calendar.current.date(byAdding: .day, value: -(days - 1), to: Date()) ?? Date()
        let filtered = entries.filter { $0.measuredAt >= cutoffDate }

        guard
            let latest = filtered.max(by: { $0.measuredAt < $1.measuredAt }),
            let earliest = filtered.min(by: { $0.measuredAt < $1.measuredAt })
        else {
            return nil
        }

        let values = filtered.map { $0.value }
        let total = values.reduce(0, +)
        let average = total / Double(values.count)

        guard let minimum = values.min(), let maximum = values.max() else {
            return nil
        }

        return ProgressSummary(
            netChange: latest.value - earliest.value,
            average: average,
            minimum: minimum,
            maximum: maximum
        )
    }

    internal var goalDistanceText: String {
        guard let goal, let latest = entries.first else {
            return "Set a goal to track progress distance."
        }

        let convertedGoalValue = preferredUnit.convertedValue(goal.targetValue, from: goal.unit)
        let delta = convertedGoalValue - latest.value
        let absDelta = abs(delta)
        let unitLabel = preferredUnit.shortLabel

        if delta == 0 {
            return "At goal"
        }

        if delta > 0 {
            return String(format: "%.1f %@ to target", absDelta, unitLabel)
        }

        return String(format: "%.1f %@ above target", absDelta, unitLabel)
    }

    private func applyPreferredUnitProjection() {
        entries = sourceEntries.map { entry in
            WeightEntry(
                id: entry.id,
                value: preferredUnit.convertedValue(entry.value, from: entry.unit),
                unit: preferredUnit,
                measuredAt: entry.measuredAt
            )
        }
    }
}
