//
//  AddWeightEntryView.swift
//  SimpleWeightTracker
//
//  Created by David Thorn on 15.02.2026.
//

import SwiftUI

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
                    AddWeightEntryHeroCardComponent()

                    AddWeightEntryFormFieldsComponent(
                        valueText: $viewModel.valueText,
                        selectedUnit: $viewModel.selectedUnit,
                        measuredAt: $viewModel.measuredAt
                    )

                    if let errorMessage = viewModel.errorMessage {
                        FormErrorCardComponent(message: errorMessage)
                    }

                    if viewModel.canSave {
                        AddWeightEntrySaveButtonComponent {
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
}

#if DEBUG
    #Preview {
        NavigationStack {
            AddWeightEntryView(serviceContainer: PreviewServiceContainer())
        }
    }
#endif
