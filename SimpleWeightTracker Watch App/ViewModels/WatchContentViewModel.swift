//
//  WatchContentViewModel.swift
//  SimpleWeightTracker Watch App
//
//  Created by David Thorn on 15.02.2026.
//

import Combine
import Foundation

@MainActor
internal final class WatchContentViewModel: ObservableObject {
    @Published internal private(set) var titleText: String
    @Published internal private(set) var symbolName: String

    internal init() {
        titleText = "Hello, world!"
        symbolName = "globe"
    }
}
