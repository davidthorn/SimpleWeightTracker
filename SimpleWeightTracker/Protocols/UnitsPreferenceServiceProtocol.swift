//
//  UnitsPreferenceServiceProtocol.swift
//  SimpleWeightTracker
//
//  Created by David Thorn on 15.02.2026.
//

import Foundation

internal protocol UnitsPreferenceServiceProtocol: Sendable {
    func observeUnit() async -> AsyncStream<WeightUnit>
    func fetchUnit() async -> WeightUnit
    func updateUnit(_ unit: WeightUnit) async
    func resetUnit() async
}
