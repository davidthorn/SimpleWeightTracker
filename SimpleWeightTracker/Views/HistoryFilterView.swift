//
//  HistoryFilterView.swift
//  SimpleWeightTracker
//
//  Created by David Thorn on 15.02.2026.
//

import SwiftUI
import SimpleFramework

internal struct HistoryFilterView: View {
    @StateObject private var viewModel: HistoryFilterViewModel

    internal init(serviceContainer: ServiceContainerProtocol) {
        let vm = HistoryFilterViewModel(serviceContainer: serviceContainer)
        _viewModel = StateObject(wrappedValue: vm)
    }

    internal var body: some View {
        ZStack {
            AppTheme.pageGradient
                .ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 14) {
                    SimpleHeroCard(
                        title: "Filter Window",
                        message: "Focus history on the window that matters now.",
                        systemImage: "line.3.horizontal.decrease.circle.fill",
                        tint: AppTheme.warning
                    )

                    HistoryFilterFormCardComponent(
                        selection: $viewModel.selection,
                        customStartDate: $viewModel.customStartDate,
                        customEndDate: $viewModel.customEndDate
                    )

                    SimpleDateRangeSummaryCard(
                        startDate: viewModel.selectedRange.lowerBound,
                        endDate: viewModel.selectedRange.upperBound,
                        tint: AppTheme.warning
                    )
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
            }
        }
        .tint(AppTheme.accent)
        .navigationTitle("History Filter")
        .task {
            if Task.isCancelled { return }
            await viewModel.load()
        }
        .onChange(of: viewModel.selection, initial: false) { _, _ in
            Task {
                if Task.isCancelled { return }
                await viewModel.persist()
            }
        }
        .onChange(of: viewModel.customStartDate, initial: false) { _, _ in
            Task {
                if Task.isCancelled { return }
                await viewModel.persist()
            }
        }
        .onChange(of: viewModel.customEndDate, initial: false) { _, _ in
            Task {
                if Task.isCancelled { return }
                await viewModel.persist()
            }
        }
    }
}

#if DEBUG
    #Preview {
        NavigationStack {
            HistoryFilterView(serviceContainer: PreviewServiceContainer())
        }
    }
#endif
