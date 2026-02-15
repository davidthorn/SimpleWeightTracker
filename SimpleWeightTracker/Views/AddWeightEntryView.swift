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
                    formHeader(
                        title: "Log Weight",
                        subtitle: "Capture today with a clean, accurate entry.",
                        systemImage: "plus.circle.fill",
                        tint: AppTheme.accent
                    )

                    VStack(alignment: .leading, spacing: 12) {
                        fieldTitle("Weight Value")
                        TextField("e.g. 74.6", text: $viewModel.valueText)
                            .keyboardType(.decimalPad)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 10)
                            .background(
                                RoundedRectangle(cornerRadius: 10, style: .continuous)
                                    .fill(Color.white.opacity(0.66))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                                            .stroke(AppTheme.border, lineWidth: 1)
                                    )
                            )

                        fieldTitle("Unit")
                        Picker("Unit", selection: $viewModel.selectedUnit) {
                            Text("kg").tag(WeightUnit.kilograms)
                            Text("lb").tag(WeightUnit.pounds)
                        }
                        .pickerStyle(.segmented)

                        fieldTitle("Measured At")
                        WeightEntryDateTimeInputComponent(measuredAt: $viewModel.measuredAt)
                    }
                    .padding(14)
                    .background(
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .fill(AppTheme.cardBackground)
                            .overlay(
                                RoundedRectangle(cornerRadius: 16, style: .continuous)
                                    .stroke(AppTheme.border, lineWidth: 1)
                            )
                    )

                    if let errorMessage = viewModel.errorMessage {
                        errorCard(errorMessage)
                    }

                    if viewModel.canSave {
                        Button {
                            Task {
                                if Task.isCancelled { return }
                                let didSave = await viewModel.save()
                                if didSave {
                                    dismiss()
                                }
                            }
                        } label: {
                            Label("Save Entry", systemImage: "checkmark.circle.fill")
                                .font(.subheadline.weight(.semibold))
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 12)
                        }
                        .buttonStyle(.plain)
                        .foregroundStyle(.white)
                        .background(
                            RoundedRectangle(cornerRadius: 12, style: .continuous)
                                .fill(AppTheme.accent)
                        )
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

    private func formHeader(title: String, subtitle: String, systemImage: String, tint: Color) -> some View {
        HStack(alignment: .top, spacing: 10) {
            Image(systemName: systemImage)
                .font(.subheadline.weight(.bold))
                .foregroundStyle(tint)
                .padding(9)
                .background(
                    Circle()
                        .fill(tint.opacity(0.14))
                )
            VStack(alignment: .leading, spacing: 3) {
                Text(title)
                    .font(.headline)
                Text(subtitle)
                    .font(.footnote)
                    .foregroundStyle(AppTheme.muted)
            }
            Spacer()
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(AppTheme.cardBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .stroke(tint.opacity(0.2), lineWidth: 1)
                )
        )
    }

    private func fieldTitle(_ title: String) -> some View {
        Text(title.uppercased())
            .font(.caption.weight(.bold))
            .foregroundStyle(AppTheme.muted)
    }

    private func errorCard(_ message: String) -> some View {
        Text(message)
            .font(.footnote)
            .foregroundStyle(AppTheme.error)
            .padding(12)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(AppTheme.error.opacity(0.08))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .stroke(AppTheme.error.opacity(0.24), lineWidth: 1)
                    )
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
