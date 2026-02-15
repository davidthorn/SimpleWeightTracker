//
//  WeightEntryEditorViewModel.swift
//  SimpleWeightTracker
//
//  Created by David Thorn on 15.02.2026.
//

import Combine
import Foundation

@MainActor
internal final class WeightEntryEditorViewModel: ObservableObject {
    @Published internal var valueText: String
    @Published internal var selectedUnit: WeightUnit
    @Published internal var measuredAt: Date
    @Published internal private(set) var errorMessage: String?
    @Published internal private(set) var initialEntry: WeightEntry?

    internal let persistedIdentifier: WeightEntryIdentifier?

    private let weightEntryService: WeightEntryServiceProtocol
    private let unitsPreferenceService: UnitsPreferenceServiceProtocol

    internal init(serviceContainer: ServiceContainerProtocol, entryIdentifier: WeightEntryIdentifier?) {
        weightEntryService = serviceContainer.weightEntryService
        unitsPreferenceService = serviceContainer.unitsPreferenceService
        persistedIdentifier = entryIdentifier
        valueText = ""
        selectedUnit = .kilograms
        measuredAt = Date()
        errorMessage = nil
        initialEntry = nil
    }

    internal var isPersisted: Bool {
        persistedIdentifier != nil
    }

    internal var hasChanges: Bool {
        guard let initialEntry else {
            return valueText.isEmpty == false
        }

        let normalizedOriginal = String(format: "%.1f", initialEntry.value)
        let normalizedInput = valueText.normalizedDecimalSeparator
        return normalizedOriginal != normalizedInput || initialEntry.unit != selectedUnit || initialEntry.measuredAt != measuredAt
    }

    internal var canSave: Bool {
        hasChanges && Double(valueText.normalizedDecimalSeparator) != nil
    }

    internal func load() async {
        guard let persistedIdentifier else {
            selectedUnit = await unitsPreferenceService.fetchUnit()
            return
        }

        do {
            let entries = try await weightEntryService.fetchEntries()
            guard let fetchedEntry = entries.first(where: { $0.id == persistedIdentifier.value }) else {
                return
            }

            initialEntry = fetchedEntry
            valueText = String(format: "%.1f", fetchedEntry.value)
            selectedUnit = fetchedEntry.unit
            measuredAt = fetchedEntry.measuredAt
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    internal func save() async -> Bool {
        let normalizedValueText = valueText.normalizedDecimalSeparator

        guard let value = Double(normalizedValueText) else {
            errorMessage = "Enter a valid weight value."
            return false
        }

        let entry = WeightEntry(
            id: persistedIdentifier?.value ?? UUID(),
            value: value,
            unit: selectedUnit,
            measuredAt: measuredAt
        )

        do {
            try await weightEntryService.upsertEntry(entry)
            initialEntry = entry
            return true
        } catch {
            errorMessage = error.localizedDescription
            return false
        }
    }

    internal func reset() {
        guard let initialEntry else { return }
        valueText = String(format: "%.1f", initialEntry.value)
        selectedUnit = initialEntry.unit
        measuredAt = initialEntry.measuredAt
        errorMessage = nil
    }

    internal func delete() async -> Bool {
        guard let persistedIdentifier else {
            return false
        }

        do {
            try await weightEntryService.deleteEntry(id: persistedIdentifier)
            return true
        } catch {
            errorMessage = error.localizedDescription
            return false
        }
    }

    internal func observeUnit() async {
        let stream = await unitsPreferenceService.observeUnit()
        for await snapshot in stream {
            guard persistedIdentifier == nil, valueText.isEmpty else {
                continue
            }
            selectedUnit = snapshot
        }
    }
}
