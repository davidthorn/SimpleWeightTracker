//
//  HomeViewModel.swift
//  SimpleWeightTracker
//
//  Created by David Thorn on 15.02.2026.
//

import Combine
import Foundation

@MainActor
internal final class HomeViewModel: ObservableObject {
    @Published internal private(set) var entries: [WeightEntry]
    @Published internal private(set) var goal: WeightGoal?
    @Published internal private(set) var preferredUnit: WeightUnit
    @Published internal private(set) var isLoading: Bool
    @Published internal private(set) var errorMessage: String?

    private let weightEntryService: WeightEntryServiceProtocol
    private let goalService: GoalServiceProtocol
    private let unitsPreferenceService: UnitsPreferenceServiceProtocol

    internal init(serviceContainer: ServiceContainerProtocol) {
        weightEntryService = serviceContainer.weightEntryService
        goalService = serviceContainer.goalService
        unitsPreferenceService = serviceContainer.unitsPreferenceService
        entries = []
        goal = nil
        preferredUnit = .kilograms
        isLoading = true
        errorMessage = nil
    }

    internal var latestEntry: WeightEntry? {
        entries.first
    }

    internal var latestEntryIdentifier: WeightEntryIdentifier? {
        guard let latestEntry else { return nil }
        return WeightEntryIdentifier(value: latestEntry.id)
    }

    internal var todayIdentifier: WeightDayIdentifier {
        WeightDayIdentifier(value: Date())
    }

    internal var todayEntries: [WeightEntry] {
        let calendar = Calendar.current
        return entries.filter { calendar.isDateInToday($0.measuredAt) }
    }

    internal var goalDistanceText: String {
        guard let goal, let latestEntry else {
            return "Set a goal and log a weight to see distance."
        }

        let convertedGoalValue = preferredUnit.convertedValue(goal.targetValue, from: goal.unit)
        let convertedLatestValue = preferredUnit.convertedValue(latestEntry.value, from: latestEntry.unit)
        let delta = convertedGoalValue - convertedLatestValue
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

    internal var latestEntryValueText: String? {
        guard let latestEntry else { return nil }
        let convertedValue = preferredUnit.convertedValue(latestEntry.value, from: latestEntry.unit)
        return String(format: "%.1f", convertedValue)
    }

    internal var latestEntryUnitText: String? {
        guard latestEntry != nil else { return nil }
        return preferredUnit.shortLabel
    }

    internal var heroGoalStatusText: String {
        guard latestEntry != nil else {
            return "Log your first weight to unlock progress insights."
        }

        return goalDistanceText
    }

    internal var heroLastLoggedText: String {
        guard let latestEntry else { return "No log today" }
        return latestEntry.measuredAt.formatted(date: .omitted, time: .shortened)
    }

    internal func load() async {
        isLoading = true
        errorMessage = nil

        do {
            async let fetchedEntries = weightEntryService.fetchEntries()
            async let fetchedGoal = goalService.fetchGoal()
            async let fetchedUnit = unitsPreferenceService.fetchUnit()

            entries = try await fetchedEntries.sorted { $0.measuredAt > $1.measuredAt }
            goal = try await fetchedGoal
            preferredUnit = await fetchedUnit
        } catch {
            errorMessage = error.localizedDescription
        }

        isLoading = false
    }

    internal func observeEntries() async {
        do {
            let stream = try await weightEntryService.observeEntries()
            for await snapshot in stream {
                entries = snapshot.sorted { $0.measuredAt > $1.measuredAt }
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
        }
    }

    internal func quickLog() async {
        let value: Double = preferredUnit == .kilograms ? 70.0 : 154.0
        let entry = WeightEntry(id: UUID(), value: value, unit: preferredUnit, measuredAt: Date())

        do {
            try await weightEntryService.upsertEntry(entry)
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
