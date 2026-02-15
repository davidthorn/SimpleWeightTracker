//
//  WeightUnit.swift
//  SimpleWeightTracker
//
//  Created by David Thorn on 15.02.2026.
//

import Foundation

/// Supported unit for weight display and input.
public nonisolated enum WeightUnit: String, Codable, CaseIterable, Sendable {
    case kilograms
    case pounds
}
