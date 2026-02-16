//
//  ProgressView.swift
//  SimpleWeightTracker
//
//  Created by David Thorn on 15.02.2026.
//

import SwiftUI

internal struct ProgressView: View {
    @StateObject private var viewModel: ProgressViewModel

    internal init(serviceContainer: ServiceContainerProtocol) {
        let vm = ProgressViewModel(serviceContainer: serviceContainer)
        _viewModel = StateObject(wrappedValue: vm)
    }

    internal var body: some View {
        ZStack {
            AppTheme.pageGradient
                .ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 14) {
                    heroCard(
                        title: "Goal Distance",
                        message: viewModel.goalDistanceText,
                        systemImage: "chart.line.uptrend.xyaxis",
                        tint: AppTheme.accent
                    )

                    summaryCard(window: .last7Days, tint: AppTheme.success)
                    summaryCard(window: .last30Days, tint: AppTheme.warning)

                    if let errorMessage = viewModel.errorMessage {
                        heroCard(
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

    private func heroCard(title: String, message: String, systemImage: String, tint: Color) -> some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: systemImage)
                .font(.title3.weight(.semibold))
                .foregroundStyle(tint)
                .frame(width: 30, height: 30)

            VStack(alignment: .leading, spacing: 6) {
                Text(title)
                    .font(.headline)
                Text(message)
                    .font(.footnote)
                    .foregroundStyle(AppTheme.muted)
            }
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(AppTheme.cardBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .stroke(tint.opacity(0.2), lineWidth: 1)
                )
        )
    }

    private func summaryCard(window: ChartWindow, tint: Color) -> some View {
        let summary = viewModel.stats(for: window)
        let points = viewModel.chartPoints(for: window)
        let movingAveragePoints = viewModel.movingAveragePoints(for: window)
        let domain = points.chartDomain()

        return VStack(alignment: .leading, spacing: 12) {
            HStack {
                Label(window.title, systemImage: "waveform.path.ecg")
                    .font(.headline)
                    .foregroundStyle(.primary)
                Spacer()
                Text("\(points.count) logs")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(tint)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(
                        Capsule(style: .continuous)
                            .fill(tint.opacity(0.14))
                    )
            }

            if let summary {
                ProgressStatsHeaderComponent(summary: summary, unitLabel: viewModel.unitLabelText)
            } else {
                Text("Not enough data")
                    .font(.footnote.weight(.semibold))
                    .foregroundStyle(AppTheme.muted)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 10)
                    .background(
                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .fill(Color.white.opacity(0.65))
                    )
            }

            if let domain {
                ProgressTrendChartComponent(
                    points: points,
                    movingAveragePoints: movingAveragePoints,
                    domain: domain,
                    unitLabel: viewModel.unitLabelText,
                    tint: tint
                )
                ProgressRangeLegendComponent(tint: tint)
            }
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(AppTheme.cardBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .stroke(tint.opacity(0.2), lineWidth: 1)
                )
        )
    }
}

#if DEBUG
    #Preview {
        NavigationStack {
            ProgressView(serviceContainer: PreviewServiceContainer())
        }
    }
#endif
