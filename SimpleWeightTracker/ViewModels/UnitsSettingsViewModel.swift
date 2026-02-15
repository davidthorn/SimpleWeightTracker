//
//  UnitsSettingsViewModel.swift
//  SimpleWeightTracker
//
//  Created by David Thorn on 15.02.2026.
//

import Combine
import Foundation

@MainActor
internal final class UnitsSettingsViewModel: ObservableObject {
    @Published internal var selectedUnit: WeightUnit
    @Published internal private(set) var initialUnit: WeightUnit

    private let unitsPreferenceService: UnitsPreferenceServiceProtocol

    internal init(serviceContainer: ServiceContainerProtocol) {
        unitsPreferenceService = serviceContainer.unitsPreferenceService
        selectedUnit = .kilograms
        initialUnit = .kilograms
    }

    internal var hasChanges: Bool {
        selectedUnit != initialUnit
    }

    internal func load() async {
        let fetched = await unitsPreferenceService.fetchUnit()
        selectedUnit = fetched
        initialUnit = fetched
    }

    internal func observeUnit() async {
        let stream = await unitsPreferenceService.observeUnit()
        for await snapshot in stream {
            let hasUnsavedChanges = hasChanges
            initialUnit = snapshot
            if hasUnsavedChanges == false {
                selectedUnit = snapshot
            }
        }
    }

    internal func save() async {
        await unitsPreferenceService.updateUnit(selectedUnit)
        initialUnit = selectedUnit
    }

    internal func reset() {
        selectedUnit = initialUnit
    }

    internal func deletePreference() async {
        await unitsPreferenceService.resetUnit()
        await load()
    }
}
