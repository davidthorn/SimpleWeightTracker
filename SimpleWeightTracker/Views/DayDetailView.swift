//
//  DayDetailView.swift
//  SimpleWeightTracker
//
//  Created by David Thorn on 15.02.2026.
//

import SwiftUI

internal struct DayDetailView: View {
    @StateObject private var viewModel: DayDetailViewModel

    internal init(serviceContainer: ServiceContainerProtocol, dayIdentifier: WeightDayIdentifier) {
        let vm = DayDetailViewModel(serviceContainer: serviceContainer, day: dayIdentifier.value)
        _viewModel = StateObject(wrappedValue: vm)
    }

    internal var body: some View {
        ZStack {
            AppTheme.pageGradient
                .ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 14) {
                    DayDetailHeroCardComponent(
                        title: "Day Summary",
                        subtitle: viewModel.subtitleText,
                        entryCount: viewModel.entryCount,
                        goalFeedbackText: viewModel.goalFeedbackText,
                        firstEntryTimeText: viewModel.firstEntryTimeText,
                        lastEntryTimeText: viewModel.lastEntryTimeText,
                        minimumValueText: viewModel.minimumValueText,
                        averageValueText: viewModel.averageValueText,
                        maximumValueText: viewModel.maximumValueText
                    )

                    if viewModel.entries.isEmpty {
                        DayDetailStatusCardComponent(
                            title: "No Entries Logged",
                            message: "Add an entry from Home and it will appear in this timeline.",
                            systemImage: "scalemass",
                            tint: AppTheme.accent
                        )
                    } else {
                        DayDetailTimelineCardComponent(
                            entries: viewModel.entries,
                            targetValue: viewModel.goalTargetValue,
                            targetUnit: viewModel.goalTargetUnit
                        )
                    }

                    if let errorMessage = viewModel.errorMessage {
                        DayDetailStatusCardComponent(
                            title: "Unable to Load Details",
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
        .navigationTitle(viewModel.titleText)
        .task {
            if Task.isCancelled { return }
            await viewModel.load()
        }
    }
}

#if DEBUG
    #Preview {
        NavigationStack {
            DayDetailView(serviceContainer: PreviewServiceContainer(), dayIdentifier: WeightDayIdentifier(value: Date()))
        }
    }
#endif
