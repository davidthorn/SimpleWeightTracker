//
//  AddWeightEntryView.swift
//  SimpleWeightTracker
//
//  Created by David Thorn on 15.02.2026.
//

import SwiftUI
import SimpleFramework

internal struct AddWeightEntryView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel: WeightEntryEditorViewModel

    internal init(serviceContainer: ServiceContainerProtocol) {
        let vm = WeightEntryEditorViewModel(serviceContainer: serviceContainer, entryIdentifier: nil)
        _viewModel = StateObject(wrappedValue: vm)
    }

    internal var body: some View {
        ZStack {
            AppTheme.pageGradient
                .ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 14) {
                    SimpleHeroCard(
                        title: "Log Weight",
                        message: "Capture today with a clean, accurate entry.",
                        systemImage: "plus.circle.fill",
                        tint: AppTheme.accent
                    )

                    SimpleLabeledTextFieldCard(
                        text: $viewModel.valueText,
                        title: "Weight Value",
                        placeholder: "e.g. 74.6"
                    )
                    .keyboardType(.decimalPad)

                    SimpleSegmentedChoiceCard(
                        selectedValue: selectedUnitBinding,
                        title: "Unit",
                        options: unitOptions
                    )

                    SimpleDateTimeInputCard(
                        date: $viewModel.measuredAt,
                        title: "Adjust Date & Time",
                        subtitle: "Pick when this measurement was captured.",
                        icon: "calendar.badge.clock",
                        accent: AppTheme.accent
                    )

                    if let errorMessage = viewModel.errorMessage {
                        SimpleFormErrorCard(message: errorMessage, tint: AppTheme.error)
                    }

                    if viewModel.canSave {
                        SimpleActionButton(
                            title: "Save Entry",
                            systemImage: "checkmark.circle.fill",
                            tint: AppTheme.accent,
                            style: .filled
                        ) {
                            Task {
                                if Task.isCancelled { return }
                                let didSave = await viewModel.save()
                                if didSave {
                                    dismiss()
                                }
                            }
                        }
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
            }
            .scrollDismissesKeyboard(.interactively)
        }
        .tint(AppTheme.accent)
        .navigationTitle("Add Entry")
        .task {
            if Task.isCancelled { return }
            await viewModel.load()
        }
        .task {
            if Task.isCancelled { return }
            await viewModel.observeUnit()
        }
    }

    private var unitOptions: [SimpleSegmentedChoiceOption] {
        [
            SimpleSegmentedChoiceOption(title: "KG", value: WeightUnit.kilograms.rawValue),
            SimpleSegmentedChoiceOption(title: "LB", value: WeightUnit.pounds.rawValue)
        ]
    }

    private var selectedUnitBinding: Binding<String> {
        Binding(
            get: { viewModel.selectedUnit.rawValue },
            set: { value in
                if let unit = WeightUnit(rawValue: value) {
                    viewModel.selectedUnit = unit
                }
            }
        )
    }
}

#if DEBUG
    #Preview {
        NavigationStack {
            AddWeightEntryView(serviceContainer: PreviewServiceContainer())
        }
    }
#endif
