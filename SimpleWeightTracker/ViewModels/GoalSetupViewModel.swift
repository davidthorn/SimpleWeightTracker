//
//  GoalSetupViewModel.swift
//  SimpleWeightTracker
//
//  Created by David Thorn on 15.02.2026.
//

import Combine
import Foundation

@MainActor
internal final class GoalSetupViewModel: ObservableObject {
    @Published internal var targetValueText: String
    @Published internal var selectedUnit: WeightUnit
    @Published internal private(set) var errorMessage: String?
    @Published internal private(set) var initialGoal: WeightGoal?

    private let goalService: GoalServiceProtocol
    private let unitsPreferenceService: UnitsPreferenceServiceProtocol

    internal init(serviceContainer: ServiceContainerProtocol) {
        goalService = serviceContainer.goalService
        unitsPreferenceService = serviceContainer.unitsPreferenceService
        targetValueText = ""
        selectedUnit = .kilograms
        errorMessage = nil
        initialGoal = nil
    }

    internal var isPersisted: Bool {
        initialGoal != nil
    }

    internal var hasChanges: Bool {
        guard let initialGoal else {
            return targetValueText.isEmpty == false
        }

        let originalText = String(format: "%.1f", initialGoal.targetValue)
        let normalizedInput = targetValueText.normalizedDecimalSeparator
        return originalText != normalizedInput || initialGoal.unit != selectedUnit
    }

    internal var canSave: Bool {
        hasChanges && Double(targetValueText.normalizedDecimalSeparator) != nil
    }

    internal func load() async {
        do {
            async let fetchedGoal = goalService.fetchGoal()
            async let preferredUnit = unitsPreferenceService.fetchUnit()

            let loadedGoal = try await fetchedGoal
            initialGoal = loadedGoal
            targetValueText = loadedGoal.map { String(format: "%.1f", $0.targetValue) } ?? ""
            if let loadedGoal {
                selectedUnit = loadedGoal.unit
            } else {
                selectedUnit = await preferredUnit
            }
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    internal func observeUnit() async {
        let stream = await unitsPreferenceService.observeUnit()
        for await snapshot in stream {
            guard initialGoal == nil, targetValueText.isEmpty else {
                continue
            }
            selectedUnit = snapshot
        }
    }

    internal func save() async -> Bool {
        let normalizedTargetValueText = targetValueText.normalizedDecimalSeparator

        guard let targetValue = Double(normalizedTargetValueText) else {
            errorMessage = "Enter a valid target value."
            return false
        }

        let goal = WeightGoal(
            id: initialGoal?.id ?? UUID(),
            targetValue: targetValue,
            unit: selectedUnit,
            updatedAt: Date()
        )

        do {
            try await goalService.upsertGoal(goal)
            initialGoal = goal
            return true
        } catch {
            errorMessage = error.localizedDescription
            return false
        }
    }

    internal func reset() {
        guard let initialGoal else { return }
        targetValueText = String(format: "%.1f", initialGoal.targetValue)
        selectedUnit = initialGoal.unit
        errorMessage = nil
    }

    internal func deleteGoal() async -> Bool {
        do {
            try await goalService.deleteGoal()
            initialGoal = nil
            targetValueText = ""
            return true
        } catch {
            errorMessage = error.localizedDescription
            return false
        }
    }
}
