//
//  String+DecimalNormalization.swift
//  SimpleWeightTracker
//
//  Created by David Thorn on 15.02.2026.
//

import Foundation

public nonisolated extension String {
    var normalizedDecimalSeparator: String {
        trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: ",", with: ".")
    }
}
