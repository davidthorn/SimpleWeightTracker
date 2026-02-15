//
//  HistoryViewModel.swift
//  SimpleWeightTracker
//
//  Created by David Thorn on 15.02.2026.
//

import Combine
import Foundation

@MainActor
internal final class HistoryViewModel: ObservableObject {
    @Published internal private(set) var dayGroups: [HistoryDayGroup]
    @Published internal private(set) var errorMessage: String?

    private let weightEntryService: WeightEntryServiceProtocol
    private let unitsPreferenceService: UnitsPreferenceServiceProtocol
    private var sourceEntries: [WeightEntry]
    private var activeFilterRange: ClosedRange<Date>?
    private var preferredUnit: WeightUnit

    internal init(serviceContainer: ServiceContainerProtocol) {
        weightEntryService = serviceContainer.weightEntryService
        unitsPreferenceService = serviceContainer.unitsPreferenceService
        dayGroups = []
        errorMessage = nil
        sourceEntries = []
        activeFilterRange = nil
        preferredUnit = .kilograms
    }

    internal func load(filterRange: ClosedRange<Date>? = nil) async {
        do {
            async let fetchedEntries = weightEntryService.fetchEntries()
            async let fetchedPreferredUnit = unitsPreferenceService.fetchUnit()
            sourceEntries = try await fetchedEntries
            preferredUnit = await fetchedPreferredUnit
            activeFilterRange = filterRange
            applyGrouping()
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    internal func observeEntries() async {
        do {
            let stream = try await weightEntryService.observeEntries()
            for await snapshot in stream {
                sourceEntries = snapshot
                applyGrouping()
            }
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    internal func observeUnit() async {
        let stream = await unitsPreferenceService.observeUnit()
        for await snapshot in stream {
            preferredUnit = snapshot
            applyGrouping()
        }
    }

    private func applyGrouping() {
        let filteredEntries = sourceEntries.filter { entry in
            guard let activeFilterRange else {
                return true
            }
            return activeFilterRange.contains(entry.measuredAt)
        }

        let projectedEntries = filteredEntries.map { entry in
            let convertedValue = preferredUnit.convertedValue(entry.value, from: entry.unit)
            return WeightEntry(
                id: entry.id,
                value: convertedValue,
                unit: preferredUnit,
                measuredAt: entry.measuredAt
            )
        }

        let grouped = Dictionary(grouping: projectedEntries) { entry in
            Calendar.current.startOfDay(for: entry.measuredAt)
        }

        dayGroups = grouped
            .map { HistoryDayGroup(day: $0.key, entries: $0.value.sorted { $0.measuredAt > $1.measuredAt }) }
            .sorted { $0.day > $1.day }
    }
}
