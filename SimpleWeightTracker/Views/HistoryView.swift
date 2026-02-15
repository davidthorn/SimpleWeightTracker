//
//  HistoryView.swift
//  SimpleWeightTracker
//
//  Created by David Thorn on 15.02.2026.
//

import SwiftUI

internal struct HistoryView: View {
    @StateObject private var viewModel: HistoryViewModel

    internal init(serviceContainer: ServiceContainerProtocol) {
        let vm = HistoryViewModel(serviceContainer: serviceContainer)
        _viewModel = StateObject(wrappedValue: vm)
    }

    internal var body: some View {
        ZStack {
            AppTheme.pageGradient
                .ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 14) {
                    HStack(spacing: 10) {
                        NavigationLink(value: HistoryRoute.addEntry) {
                            topAction(title: "Add Entry", systemImage: "plus.circle.fill", tint: AppTheme.accent)
                        }
                        .buttonStyle(.plain)

                        NavigationLink(value: HistoryRoute.filter) {
                            topAction(title: "Filters", systemImage: "line.3.horizontal.decrease.circle", tint: AppTheme.warning)
                        }
                        .buttonStyle(.plain)
                    }

                    if viewModel.dayGroups.isEmpty {
                        statusCard(
                            title: "No History Yet",
                            message: "Log your first weight and it will appear here.",
                            systemImage: "clock.badge.questionmark",
                            tint: AppTheme.accent
                        )
                    } else {
                        ForEach(viewModel.dayGroups, id: \.day) { group in
                            VStack(alignment: .leading, spacing: 12) {
                                NavigationLink(value: HistoryRoute.dayDetail(WeightDayIdentifier(value: group.day))) {
                                    HStack(alignment: .top, spacing: 10) {
                                        VStack(alignment: .leading, spacing: 0) {
                                            Text(group.day.formatted(date: .abbreviated, time: .omitted))
                                                .font(.headline)
                                                .foregroundStyle(.primary)
                                        }

                                        Spacer()

                                        Text("\(group.entries.count) logs")
                                            .font(.caption.weight(.semibold))
                                            .foregroundStyle(AppTheme.accent)
                                            .padding(.horizontal, 10)
                                            .padding(.vertical, 6)
                                            .background(
                                                Capsule(style: .continuous)
                                                    .fill(AppTheme.accent.opacity(0.12))
                                            )
                                    }
                                }
                                .buttonStyle(.plain)

                                HistoryDayStatsComponent(group: group)
                                HistoryDayCardComponent(entries: group.entries)
                            }
                            .padding(12)
                            .background(
                                RoundedRectangle(cornerRadius: 18, style: .continuous)
                                    .fill(Color.white.opacity(0.56))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 18, style: .continuous)
                                            .stroke(Color.white.opacity(0.8), lineWidth: 1)
                                    )
                            )
                            .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 4)
                        }
                    }

                    if let errorMessage = viewModel.errorMessage {
                        statusCard(
                            title: "Unable to Load History",
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
        .navigationTitle("History")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                NavigationLink(value: HistoryRoute.addEntry) {
                    Image(systemName: "plus")
                }
            }
        }
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
            await viewModel.observeUnit()
        }
    }

    private func topAction(title: String, systemImage: String, tint: Color) -> some View {
        HStack(spacing: 6) {
            Image(systemName: systemImage)
            Text(title)
                .lineLimit(1)
        }
        .font(.subheadline.weight(.semibold))
        .foregroundStyle(tint)
        .frame(maxWidth: .infinity)
        .padding(.vertical, 10)
        .background(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(AppTheme.cardBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .stroke(tint.opacity(0.2), lineWidth: 1)
                )
        )
    }

    private func statusCard(title: String, message: String, systemImage: String, tint: Color) -> some View {
        VStack(spacing: 10) {
            Image(systemName: systemImage)
                .font(.system(size: 24, weight: .semibold))
                .foregroundStyle(tint)
            Text(title)
                .font(.headline)
            Text(message)
                .font(.footnote)
                .foregroundStyle(AppTheme.muted)
                .multilineTextAlignment(.center)
        }
        .padding(20)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(AppTheme.cardBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .stroke(tint.opacity(0.18), lineWidth: 1)
                )
        )
    }
}

#if DEBUG
    #Preview {
        NavigationStack {
            HistoryView(serviceContainer: PreviewServiceContainer())
        }
    }
#endif
