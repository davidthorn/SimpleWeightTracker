//
//  ContentViewModel.swift
//  SimpleWeightTracker
//
//  Created by David Thorn on 15.02.2026.
//

import Combine
import Foundation

@MainActor
internal final class ContentViewModel: ObservableObject {
    @Published internal private(set) var titleText: String
    @Published internal private(set) var symbolName: String

    internal init() {
        titleText = "Hello, world!"
        symbolName = "globe"
    }
}
