//
//  WeightUnit+Conversion.swift
//  SimpleWeightTracker
//
//  Created by David Thorn on 15.02.2026.
//

import Foundation

public nonisolated extension WeightUnit {
    var shortLabel: String {
        switch self {
        case .kilograms:
            return "kg"
        case .pounds:
            return "lb"
        }
    }

    func convertedValue(_ value: Double, from sourceUnit: WeightUnit) -> Double {
        guard self != sourceUnit else {
            return value
        }

        switch (sourceUnit, self) {
        case (.kilograms, .pounds):
            return value * 2.204_622_621_8
        case (.pounds, .kilograms):
            return value / 2.204_622_621_8
        default:
            return value
        }
    }
}
