//
//  HomeView.swift
//  SimpleWeightTracker
//
//  Created by David Thorn on 15.02.2026.
//

import SwiftUI

internal struct HomeView: View {
    @StateObject private var viewModel: HomeViewModel

    internal init(serviceContainer: ServiceContainerProtocol) {
        let vm = HomeViewModel(serviceContainer: serviceContainer)
        _viewModel = StateObject(wrappedValue: vm)
    }

    internal var body: some View {
        ZStack {
            AppTheme.pageGradient
                .ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 14) {
                    HomeHeroCardComponent(
                        latestValueText: viewModel.latestEntryValueText,
                        latestUnitText: viewModel.latestEntryUnitText,
                        goalStatusText: viewModel.heroGoalStatusText,
                        todayLogCount: viewModel.todayEntries.count,
                        lastLoggedText: viewModel.heroLastLoggedText
                    )

                    HomeMiniTrendCardComponent(
                        entries: viewModel.entries,
                        preferredUnit: viewModel.preferredUnit
                    )

                    VStack(spacing: 10) {
                        NavigationLink(value: HomeRoute.addEntry) {
                            RouteRowComponent(
                                title: "Add Weight Entry",
                                subtitle: "Log a new measurement",
                                systemImage: "plus.circle.fill",
                                tint: AppTheme.accent
                            )
                        }
                        .buttonStyle(.plain)

                        if let latestIdentifier = viewModel.latestEntryIdentifier {
                            NavigationLink(value: HomeRoute.editEntry(latestIdentifier)) {
                                RouteRowComponent(
                                    title: "Edit Latest Entry",
                                    subtitle: "Adjust your most recent log",
                                    systemImage: "pencil.circle.fill",
                                    tint: AppTheme.warning
                                )
                            }
                            .buttonStyle(.plain)
                        }

                        NavigationLink(value: HomeRoute.dayDetail(viewModel.todayIdentifier)) {
                            RouteRowComponent(
                                title: "Today Details",
                                subtitle: "Review every entry from today",
                                systemImage: "calendar",
                                tint: AppTheme.success
                            )
                        }
                        .buttonStyle(.plain)

                        NavigationLink(value: HomeRoute.goalSetup) {
                            RouteRowComponent(
                                title: "Set Target Weight",
                                subtitle: "Define your target and unit",
                                systemImage: "target",
                                tint: AppTheme.accent
                            )
                        }
                        .buttonStyle(.plain)
                    }

                    if let errorMessage = viewModel.errorMessage {
                        HomeStatusCardComponent(
                            title: "Unable to Refresh Home",
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
        .navigationTitle("Home")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                NavigationLink(value: HomeRoute.addEntry) {
                    Image(systemName: "plus")
                        .font(.headline)
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
            await viewModel.observeGoal()
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
            HomeView(serviceContainer: PreviewServiceContainer())
        }
    }
#endif
