//
//  WeightProgressView.swift
//  SimpleWeightTracker
//
//  Created by David Thorn on 15.02.2026.
//

import SwiftUI

internal struct WeightProgressView: View {
    @StateObject private var viewModel: WeightProgressViewModel

    internal init(serviceContainer: ServiceContainerProtocol) {
        let vm = WeightProgressViewModel(serviceContainer: serviceContainer)
        _viewModel = StateObject(wrappedValue: vm)
    }

    internal var body: some View {
        ZStack {
            AppTheme.pageGradient
                .ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 14) {
                    WeightProgressHeroCardComponent(
                        title: "Goal Distance",
                        message: viewModel.goalDistanceText,
                        systemImage: "chart.line.uptrend.xyaxis",
                        tint: AppTheme.accent
                    )

                    WeightProgressSummaryCardComponent(
                        content: summaryContent(window: .last7Days),
                        tint: AppTheme.success
                    )
                    WeightProgressSummaryCardComponent(
                        content: summaryContent(window: .last30Days),
                        tint: AppTheme.warning
                    )

                    if let errorMessage = viewModel.errorMessage {
                        WeightProgressHeroCardComponent(
                            title: "Unable to Load Progress",
                            message: errorMessage,
                            systemImage: "exclamationmark.triangle.fill",
                            tint: AppTheme.error
                        )
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
            }
        }
        .navigationTitle("Progress")
        .task {
            if Task.isCancelled { return }
            await viewModel.load()
        }
        .task {
            if Task.isCancelled { return }
            await viewModel.observeEntries()
        }
        .task {
            if Task.isCancelled { return }
            await viewModel.observeGoal()
        }
        .task {
            if Task.isCancelled { return }
            await viewModel.observeUnit()
        }
    }

    private func summaryContent(window: ChartWindow) -> ProgressSummaryCardContent {
        let summary = viewModel.stats(for: window)
        let points = viewModel.chartPoints(for: window)
        let movingAveragePoints = viewModel.movingAveragePoints(for: window)
        let domain = points.chartDomain()

        return ProgressSummaryCardContent(
            windowTitle: window.title,
            logCount: points.count,
            summary: summary,
            points: points,
            movingAveragePoints: movingAveragePoints,
            domain: domain,
            unitLabel: viewModel.unitLabelText
        )
    }
}

#if DEBUG
    #Preview {
        NavigationStack {
            WeightProgressView(serviceContainer: PreviewServiceContainer())
        }
    }
#endif
