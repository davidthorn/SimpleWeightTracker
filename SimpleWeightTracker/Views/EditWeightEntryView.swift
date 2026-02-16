//
//  EditWeightEntryView.swift
//  SimpleWeightTracker
//
//  Created by David Thorn on 15.02.2026.
//

import SwiftUI

internal struct EditWeightEntryView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel: WeightEntryEditorViewModel
    @State private var showingDeleteConfirmation: Bool

    internal init(serviceContainer: ServiceContainerProtocol, entryIdentifier: WeightEntryIdentifier) {
        let vm = WeightEntryEditorViewModel(serviceContainer: serviceContainer, entryIdentifier: entryIdentifier)
        _viewModel = StateObject(wrappedValue: vm)
        _showingDeleteConfirmation = State(initialValue: false)
    }

    internal var body: some View {
        ZStack {
            AppTheme.pageGradient
                .ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 14) {
                    formHeader(
                        title: "Edit Entry",
                        subtitle: "Refine this log and keep your timeline precise.",
                        systemImage: "pencil.circle.fill",
                        tint: AppTheme.warning
                    )

                    VStack(alignment: .leading, spacing: 12) {
                        fieldTitle("Weight Value")
                        TextField("e.g. 74.6", text: $viewModel.valueText)
                            .keyboardType(.decimalPad)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 10)
                            .background(inputBackground)

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
                    .background(cardBackground)

                    if viewModel.isPersisted {
                        healthKitSyncCard
                    }

                    if let errorMessage = viewModel.errorMessage {
                        FormErrorCardComponent(message: errorMessage)
                    }

                    VStack(spacing: 10) {
                        if viewModel.canSave {
                            ActionButtonComponent(
                                title: "Save Changes",
                                systemImage: "checkmark.circle.fill",
                                tint: AppTheme.accent
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

                        if viewModel.isPersisted && viewModel.hasChanges {
                            ActionButtonComponent(
                                title: "Reset",
                                systemImage: "arrow.uturn.backward.circle.fill",
                                tint: AppTheme.warning
                            ) {
                                viewModel.reset()
                            }
                        }

                        if viewModel.isPersisted {
                            ActionButtonComponent(
                                title: "Delete Entry",
                                systemImage: "trash.fill",
                                tint: AppTheme.error
                            ) {
                                showingDeleteConfirmation = true
                            }
                        }
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
            }
            .scrollDismissesKeyboard(.interactively)

            if showingDeleteConfirmation {
                Color.black.opacity(0.16)
                    .ignoresSafeArea()
                    .onTapGesture {
                        showingDeleteConfirmation = false
                    }

                DestructiveConfirmationCardComponent(
                    title: "Delete this entry?",
                    message: "This permanently removes the weight log from your history.",
                    confirmTitle: "Delete Entry",
                    tint: AppTheme.error,
                    isDisabled: false,
                    onCancel: {
                        showingDeleteConfirmation = false
                    },
                    onConfirm: {
                        Task {
                            if Task.isCancelled { return }
                            let didDelete = await viewModel.delete()
                            if didDelete {
                                dismiss()
                            } else {
                                showingDeleteConfirmation = false
                            }
                        }
                    }
                )
                .padding(.horizontal, 16)
                .transition(.opacity.combined(with: .scale(scale: 0.98)))
            }
        }
        .tint(AppTheme.accent)
        .navigationTitle("Edit Entry")
        .task {
            if Task.isCancelled { return }
            await viewModel.load()
        }
        .task {
            if Task.isCancelled { return }
            await viewModel.observeUnit()
        }
        .task {
            if Task.isCancelled { return }
            await viewModel.refreshSyncStatus()
        }
        .animation(.easeInOut(duration: 0.2), value: showingDeleteConfirmation)
    }

    private var healthKitSyncCard: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 10) {
                Image(systemName: "heart.text.square.fill")
                    .font(.subheadline.weight(.bold))
                    .foregroundStyle(AppTheme.error)
                    .frame(width: 30, height: 30)
                    .background(
                        RoundedRectangle(cornerRadius: 8, style: .continuous)
                            .fill(AppTheme.error.opacity(0.12))
                    )

                VStack(alignment: .leading, spacing: 2) {
                    Text("HealthKit Sync")
                        .font(.subheadline.weight(.semibold))
                    Text(viewModel.syncStatusText)
                        .font(.footnote)
                        .foregroundStyle(AppTheme.muted)
                }

                Spacer()
            }

            if viewModel.syncMetadata == nil {
                ActionButtonComponent(
                    title: viewModel.isSyncingToHealthKit ? "Syncing..." : "Sync Entry to HealthKit",
                    systemImage: "arrow.triangle.2.circlepath.circle.fill",
                    tint: AppTheme.success
                ) {
                    Task {
                        if Task.isCancelled { return }
                        await viewModel.syncPersistedEntryToHealthKit()
                    }
                }
                .disabled(viewModel.isSyncingToHealthKit || viewModel.canSyncToHealthKit == false)
                .opacity(viewModel.canSyncToHealthKit ? 1 : 0.55)
            }
        }
        .padding(14)
        .background(cardBackground)
    }

    private var cardBackground: some View {
        RoundedRectangle(cornerRadius: 16, style: .continuous)
            .fill(AppTheme.cardBackground)
            .overlay(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .stroke(AppTheme.border, lineWidth: 1)
            )
    }

    private var inputBackground: some View {
        RoundedRectangle(cornerRadius: 10, style: .continuous)
            .fill(Color.white.opacity(0.66))
            .overlay(
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .stroke(AppTheme.border, lineWidth: 1)
            )
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
}

#if DEBUG
    #Preview {
        NavigationStack {
            EditWeightEntryView(serviceContainer: PreviewServiceContainer(), entryIdentifier: WeightEntryIdentifier(value: UUID()))
        }
    }
#endif
