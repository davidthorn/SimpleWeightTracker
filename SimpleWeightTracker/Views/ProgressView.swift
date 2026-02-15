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

                    summaryCard(title: "7 Day Trend", summary: viewModel.summary(days: 7), tint: AppTheme.success)
                    summaryCard(title: "30 Day Trend", summary: viewModel.summary(days: 30), tint: AppTheme.warning)

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

    private func summaryCard(title: String, summary: ProgressSummary?, tint: Color) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Label(title, systemImage: "waveform.path.ecg")
                    .font(.headline)
                    .foregroundStyle(.primary)
                Spacer()
                trendBadge(summary: summary, tint: tint)
            }

            if let summary {
                VStack(alignment: .leading, spacing: 2) {
                    Text(formattedValue(summary.netChange))
                        .font(.title2.weight(.bold))
                        .foregroundStyle(summary.netChange >= 0 ? AppTheme.success : AppTheme.warning)
                    Text(summary.netChange >= 0 ? "Net gain over this period" : "Net loss over this period")
                        .font(.caption)
                        .foregroundStyle(AppTheme.muted)
                }

                rangeTrack(summary: summary, tint: tint)

                LazyVGrid(
                    columns: [GridItem(.flexible(), spacing: 8), GridItem(.flexible(), spacing: 8)],
                    spacing: 8
                ) {
                    statPill(
                        title: "Average",
                        value: formattedValue(summary.average),
                        symbol: "sum"
                    )
                    statPill(
                        title: "Range",
                        value: formattedValue(summary.maximum - summary.minimum),
                        symbol: "arrow.left.and.right"
                    )
                    statPill(
                        title: "Minimum",
                        value: formattedValue(summary.minimum),
                        symbol: "arrow.down.to.line"
                    )
                    statPill(
                        title: "Maximum",
                        value: formattedValue(summary.maximum),
                        symbol: "arrow.up.to.line"
                    )
                }
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

    @ViewBuilder
    private func trendBadge(summary: ProgressSummary?, tint: Color) -> some View {
        if let summary {
            let isGain = summary.netChange >= 0
            Label(isGain ? "Up" : "Down", systemImage: isGain ? "arrow.up.right" : "arrow.down.right")
                .font(.caption.weight(.semibold))
                .foregroundStyle(isGain ? AppTheme.success : AppTheme.warning)
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
                .background(
                    Capsule(style: .continuous)
                        .fill((isGain ? AppTheme.success : AppTheme.warning).opacity(0.14))
                )
        } else {
            Label("Waiting", systemImage: "clock")
                .font(.caption.weight(.semibold))
                .foregroundStyle(tint)
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
                .background(
                    Capsule(style: .continuous)
                        .fill(tint.opacity(0.14))
                )
        }
    }

    private func rangeTrack(summary: ProgressSummary, tint: Color) -> some View {
        let minimum = summary.minimum
        let maximum = summary.maximum
        let average = summary.average
        let span = max(maximum - minimum, 0.0001)

        return VStack(alignment: .leading, spacing: 6) {
            Text("Range")
                .font(.caption.weight(.medium))
                .foregroundStyle(AppTheme.muted)

            GeometryReader { geo in
                let width = max(geo.size.width, 1)
                let avgX = CGFloat((average - minimum) / span) * width

                ZStack(alignment: .leading) {
                    Capsule(style: .continuous)
                        .fill(Color.white.opacity(0.7))
                        .frame(height: 8)

                    Capsule(style: .continuous)
                        .fill(tint.opacity(0.26))
                        .frame(height: 8)

                    Circle()
                        .fill(tint)
                        .frame(width: 12, height: 12)
                        .overlay(
                            Circle()
                                .stroke(Color.white, lineWidth: 2)
                        )
                        .position(x: min(max(avgX, 6), max(width - 6, 6)), y: 4)
                }
            }
            .frame(height: 12)

            HStack {
                Text("Min \(formattedValue(minimum))")
                Spacer()
                Text("Avg \(formattedValue(average))")
                Spacer()
                Text("Max \(formattedValue(maximum))")
            }
            .font(.caption2)
            .foregroundStyle(AppTheme.muted)
        }
    }

    private func statPill(title: String, value: String, symbol: String) -> some View {
        HStack(spacing: 8) {
            Image(systemName: symbol)
                .font(.caption.weight(.semibold))
                .foregroundStyle(AppTheme.accent)
                .frame(width: 20, height: 20)
                .background(
                    RoundedRectangle(cornerRadius: 6, style: .continuous)
                        .fill(AppTheme.accent.opacity(0.12))
                )

            VStack(alignment: .leading, spacing: 1) {
                Text(title)
                    .font(.caption.weight(.medium))
                    .foregroundStyle(AppTheme.muted)
                Text(value)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.primary)
            }

            Spacer(minLength: 0)
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 7)
        .background(
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .fill(Color.white.opacity(0.65))
        )
    }

    private func formattedValue(_ value: Double) -> String {
        String(format: "%.1f", value)
    }
}

#if DEBUG
    #Preview {
        NavigationStack {
            ProgressView(serviceContainer: PreviewServiceContainer())
        }
    }
#endif
