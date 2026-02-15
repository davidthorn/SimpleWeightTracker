//
//  HistoryFilterView.swift
//  SimpleWeightTracker
//
//  Created by David Thorn on 15.02.2026.
//

import SwiftUI

internal struct HistoryFilterView: View {
    @StateObject private var viewModel: HistoryFilterViewModel

    internal init() {
        let vm = HistoryFilterViewModel()
        _viewModel = StateObject(wrappedValue: vm)
    }

    internal var body: some View {
        ZStack {
            AppTheme.pageGradient
                .ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 14) {
                    formHeader(
                        title: "Filter Window",
                        subtitle: "Focus history on the window that matters now.",
                        systemImage: "line.3.horizontal.decrease.circle.fill",
                        tint: AppTheme.warning
                    )

                    VStack(alignment: .leading, spacing: 12) {
                        fieldTitle("Range")
                        Picker("Range", selection: $viewModel.selection) {
                            Text("Last 7 Days").tag(HistoryFilterSelection.last7Days)
                            Text("Last 30 Days").tag(HistoryFilterSelection.last30Days)
                            Text("Custom").tag(HistoryFilterSelection.custom)
                        }
                        .pickerStyle(.segmented)

                        if viewModel.selection == .custom {
                            fieldTitle("Custom Dates")
                            DatePicker("Start", selection: $viewModel.customStartDate, displayedComponents: .date)
                                .datePickerStyle(.compact)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 10)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(inputBackground)
                            DatePicker("End", selection: $viewModel.customEndDate, displayedComponents: .date)
                                .datePickerStyle(.compact)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 10)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(inputBackground)
                        }
                    }
                    .padding(14)
                    .background(cardBackground)

                    VStack(alignment: .leading, spacing: 8) {
                        fieldTitle("Selected Range")
                        statRow(title: "Start", value: viewModel.selectedRange.lowerBound.formatted(date: .abbreviated, time: .omitted))
                        statRow(title: "End", value: viewModel.selectedRange.upperBound.formatted(date: .abbreviated, time: .omitted))
                    }
                    .padding(14)
                    .background(cardBackground)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
            }
        }
        .tint(AppTheme.accent)
        .navigationTitle("History Filter")
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

    private func statRow(title: String, value: String) -> some View {
        HStack {
            Text(title)
                .font(.subheadline.weight(.semibold))
            Spacer()
            Text(value)
                .font(.subheadline)
                .foregroundStyle(AppTheme.muted)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 9)
        .background(inputBackground)
    }
}

#if DEBUG
    #Preview {
        NavigationStack {
            HistoryFilterView()
        }
    }
#endif
