//
//  WeightEntryEditorViewModel.swift
//  SimpleWeightTracker
//
//  Created by David Thorn on 15.02.2026.
//

import Combine
import Foundation
import HealthKit
import SimpleFramework

@MainActor
internal final class WeightEntryEditorViewModel: ObservableObject {
    private static let syncDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }()

    private static func detailedErrorMessage(_ error: Error) -> String {
        let nsError = error as NSError
        var lines: [String] = []
        lines.append("Type: \(String(reflecting: type(of: error)))")
        lines.append("Description: \(error.localizedDescription)")
        lines.append("Debug: \(String(reflecting: error))")
        lines.append("Domain: \(nsError.domain)")
        lines.append("Code: \(nsError.code)")

        if nsError.userInfo.isEmpty == false {
            lines.append("UserInfo: \(nsError.userInfo)")
        }

        if let underlyingError = nsError.userInfo[NSUnderlyingErrorKey] as? Error {
            lines.append("Underlying: \(String(reflecting: underlyingError))")
        }

        return lines.joined(separator: "\n")
    }

    @Published internal var valueText: String
    @Published internal var selectedUnit: WeightUnit
    @Published internal var measuredAt: Date
    @Published internal private(set) var errorMessage: String?
    @Published internal private(set) var initialEntry: WeightEntry?
    @Published internal private(set) var syncMetadata: HealthKitEntrySyncMetadata?
    @Published internal private(set) var healthKitPermissionState: HealthKitPermissionState
    @Published internal private(set) var isSyncingToHealthKit: Bool

    internal let persistedIdentifier: WeightEntryIdentifier?

    private let weightEntryService: WeightEntryServiceProtocol
    private let unitsPreferenceService: UnitsPreferenceServiceProtocol
    private let healthKitWeightService: HealthKitQuantitySyncServiceProtocol
    private let weightEntrySyncMetadataService: HealthKitEntrySyncMetadataServiceProtocol

    internal init(serviceContainer: ServiceContainerProtocol, entryIdentifier: WeightEntryIdentifier?) {
        weightEntryService = serviceContainer.weightEntryService
        unitsPreferenceService = serviceContainer.unitsPreferenceService
        healthKitWeightService = serviceContainer.healthKitWeightService
        weightEntrySyncMetadataService = serviceContainer.weightEntrySyncMetadataService
        persistedIdentifier = entryIdentifier
        valueText = ""
        selectedUnit = .kilograms
        measuredAt = Date()
        errorMessage = nil
        initialEntry = nil
        syncMetadata = nil
        healthKitPermissionState = .unavailable()
        isSyncingToHealthKit = false
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
        healthKitPermissionState = await healthKitWeightService.fetchPermissionState()

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
            syncMetadata = try await weightEntrySyncMetadataService.fetchMetadata(
                for: persistedIdentifier.value,
                providerIdentifier: healthKitWeightService.providerIdentifier
            )
        } catch {
            errorMessage = Self.detailedErrorMessage(error)
        }
    }

    internal func save() async -> Bool {
        let isNewEntry = persistedIdentifier == nil
        let shouldInvalidateSyncMetadata = isNewEntry == false && hasChanges
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
            if isNewEntry {
                let externalIdentifier = try await healthKitWeightService.syncSampleIfEnabled(
                    value: WeightUnit.kilograms.convertedValue(entry.value, from: entry.unit),
                    unit: .gramUnit(with: .kilo),
                    start: entry.measuredAt,
                    end: entry.measuredAt
                )
                if let externalIdentifier {
                    let metadata = HealthKitEntrySyncMetadata(
                        entryID: entry.id,
                        providerIdentifier: healthKitWeightService.providerIdentifier,
                        externalIdentifier: externalIdentifier,
                        syncedAt: Date()
                    )
                    try await weightEntrySyncMetadataService.upsertMetadata(metadata)
                    syncMetadata = metadata
                }
            } else if shouldInvalidateSyncMetadata, let persistedIdentifier {
                try await weightEntrySyncMetadataService.deleteMetadata(for: persistedIdentifier.value)
                syncMetadata = nil
            }
            initialEntry = entry
            errorMessage = nil
            return true
        } catch {
            errorMessage = Self.detailedErrorMessage(error)
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
            try await weightEntrySyncMetadataService.deleteMetadata(for: persistedIdentifier.value)
            return true
        } catch {
            errorMessage = Self.detailedErrorMessage(error)
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

    internal func refreshSyncStatus() async {
        healthKitPermissionState = await healthKitWeightService.fetchPermissionState()

        guard let persistedIdentifier else {
            syncMetadata = nil
            return
        }

        do {
            syncMetadata = try await weightEntrySyncMetadataService.fetchMetadata(
                for: persistedIdentifier.value,
                providerIdentifier: healthKitWeightService.providerIdentifier
            )
        } catch {
            syncMetadata = nil
            errorMessage = Self.detailedErrorMessage(error)
        }
    }

    internal var canSyncToHealthKit: Bool {
        isPersisted && healthKitPermissionState.write == .authorized
    }

    internal var syncStatusText: String {
        if let syncMetadata {
            return "Synced to HealthKit on \(Self.syncDateFormatter.string(from: syncMetadata.syncedAt))."
        }

        if healthKitPermissionState.write == .authorized {
            return "Not synced yet."
        }

        if healthKitPermissionState.write == .denied {
            return "HealthKit write permission denied."
        }

        if healthKitPermissionState.write == .notDetermined {
            return "HealthKit write permission not requested."
        }

        return "HealthKit is unavailable."
    }

    internal func syncPersistedEntryToHealthKit() async {
        guard let persistedIdentifier else { return }
        guard let entry = initialEntry else { return }
        isSyncingToHealthKit = true
        defer { isSyncingToHealthKit = false }

        do {
            let externalIdentifier = try await healthKitWeightService.syncSample(
                value: WeightUnit.kilograms.convertedValue(entry.value, from: entry.unit),
                unit: .gramUnit(with: .kilo),
                start: entry.measuredAt,
                end: entry.measuredAt
            )
            let metadata = HealthKitEntrySyncMetadata(
                entryID: persistedIdentifier.value,
                providerIdentifier: healthKitWeightService.providerIdentifier,
                externalIdentifier: externalIdentifier,
                syncedAt: Date()
            )
            try await weightEntrySyncMetadataService.upsertMetadata(metadata)
            syncMetadata = metadata
            healthKitPermissionState = await healthKitWeightService.fetchPermissionState()
            errorMessage = nil
        } catch {
            errorMessage = Self.detailedErrorMessage(error)
            healthKitPermissionState = await healthKitWeightService.fetchPermissionState()
        }
    }
}
