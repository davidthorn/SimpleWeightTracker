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
                LazyVStack(alignment: .leading, spacing: 14) {
                    HStack(spacing: 10) {
                        NavigationLink(value: HistoryRoute.addEntry) {
                            HistoryTopActionComponent(
                                title: "Add Entry",
                                systemImage: "plus.circle.fill",
                                tint: AppTheme.accent
                            )
                        }
                        .buttonStyle(.plain)

                        NavigationLink(value: HistoryRoute.filter) {
                            HistoryTopActionComponent(
                                title: "Filters",
                                systemImage: "line.3.horizontal.decrease.circle",
                                tint: AppTheme.warning
                            )
                        }
                        .buttonStyle(.plain)
                    }

                    if viewModel.dayGroups.isEmpty {
                        HistoryStatusCardComponent(
                            title: "No History Yet",
                            message: "Log your first weight and it will appear here.",
                            systemImage: "clock.badge.questionmark",
                            tint: AppTheme.accent
                        )
                    } else {
                        ForEach(viewModel.dayGroups, id: \.day) { group in
                            HistoryDayGroupComponent(group: group)
                        }
                    }

                    if let errorMessage = viewModel.errorMessage {
                        HistoryStatusCardComponent(
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
}

#if DEBUG
    #Preview {
        NavigationStack {
            HistoryView(serviceContainer: PreviewServiceContainer())
        }
    }
#endif
