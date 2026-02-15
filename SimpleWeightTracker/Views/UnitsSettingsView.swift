//
//  UnitsSettingsView.swift
//  SimpleWeightTracker
//
//  Created by David Thorn on 15.02.2026.
//

import SwiftUI

internal struct UnitsSettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel: UnitsSettingsViewModel
    @State private var showingDeleteConfirmation: Bool

    internal init(serviceContainer: ServiceContainerProtocol) {
        let vm = UnitsSettingsViewModel(serviceContainer: serviceContainer)
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
                        title: "Unit Preference",
                        subtitle: "Pick your base measurement language.",
                        systemImage: "scalemass",
                        tint: AppTheme.accent
                    )

                    VStack(alignment: .leading, spacing: 12) {
                        fieldTitle("Preferred Unit")
                        Picker("Unit", selection: $viewModel.selectedUnit) {
                            Text("kg").tag(WeightUnit.kilograms)
                            Text("lb").tag(WeightUnit.pounds)
                        }
                        .pickerStyle(.segmented)
                    }
                    .padding(14)
                    .background(cardBackground)

                    VStack(spacing: 10) {
                        if viewModel.hasChanges {
                            actionButton(
                                title: "Save Preference",
                                systemImage: "checkmark.circle.fill",
                                tint: AppTheme.accent
                            ) {
                                Task {
                                    if Task.isCancelled { return }
                                    await viewModel.save()
                                    dismiss()
                                }
                            }

                            actionButton(
                                title: "Reset",
                                systemImage: "arrow.uturn.backward.circle.fill",
                                tint: AppTheme.warning
                            ) {
                                viewModel.reset()
                            }
                        }

                        actionButton(
                            title: "Delete Preference",
                            systemImage: "trash.fill",
                            tint: AppTheme.error
                        ) {
                            showingDeleteConfirmation = true
                        }
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
            }
        }
        .tint(AppTheme.accent)
        .navigationTitle("Units")
        .task {
            if Task.isCancelled { return }
            await viewModel.load()
        }
        .task {
            if Task.isCancelled { return }
            await viewModel.observeUnit()
        }
        .confirmationDialog("Are you sure you want to delete this?", isPresented: $showingDeleteConfirmation, titleVisibility: .visible) {
            Button("Delete", role: .destructive) {
                Task {
                    if Task.isCancelled { return }
                    await viewModel.deletePreference()
                    dismiss()
                }
            }
            Button("Cancel", role: .cancel) {}
        }
    }

    private var cardBackground: some View {
        RoundedRectangle(cornerRadius: 16, style: .continuous)
            .fill(AppTheme.cardBackground)
            .overlay(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
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

    private func actionButton(title: String, systemImage: String, tint: Color, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Label(title, systemImage: systemImage)
                .font(.subheadline.weight(.semibold))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
        }
        .buttonStyle(.plain)
        .foregroundStyle(.white)
        .background(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(tint)
        )
    }
}

#if DEBUG
    #Preview {
        NavigationStack {
            UnitsSettingsView(serviceContainer: PreviewServiceContainer())
        }
    }
#endif
