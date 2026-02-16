//
//  HistoryFilterViewModel.swift
//  SimpleWeightTracker
//
//  Created by David Thorn on 15.02.2026.
//

import Combine
import Foundation

@MainActor
internal final class HistoryFilterViewModel: ObservableObject {
    @Published internal var selection: HistoryFilterSelection
    @Published internal var customStartDate: Date
    @Published internal var customEndDate: Date

    private let historyFilterService: HistoryFilterServiceProtocol

    internal init(serviceContainer: ServiceContainerProtocol) {
        historyFilterService = serviceContainer.historyFilterService
        let initialConfiguration = HistoryFilterConfiguration.defaultValue()
        selection = initialConfiguration.selection
        customStartDate = initialConfiguration.customStartDate
        customEndDate = initialConfiguration.customEndDate
    }

    internal var selectedRange: ClosedRange<Date> {
        makeConfiguration().resolvedRange()
    }

    internal func load() async {
        let configuration = await historyFilterService.fetchConfiguration()
        selection = configuration.selection
        customStartDate = configuration.customStartDate
        customEndDate = configuration.customEndDate
    }

    internal func persist() async {
        await historyFilterService.updateConfiguration(makeConfiguration())
    }

    private func makeConfiguration() -> HistoryFilterConfiguration {
        HistoryFilterConfiguration(
            selection: selection,
            customStartDate: customStartDate,
            customEndDate: customEndDate
        )
    }
}
