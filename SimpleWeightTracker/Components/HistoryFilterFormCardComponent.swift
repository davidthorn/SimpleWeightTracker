//
//  HistoryFilterFormCardComponent.swift
//  SimpleWeightTracker
//
//  Created by David Thorn on 16.02.2026.
//

import SwiftUI

internal struct HistoryFilterFormCardComponent: View {
    @Binding private var selection: HistoryFilterSelection
    @Binding private var customStartDate: Date
    @Binding private var customEndDate: Date

    internal init(selection: Binding<HistoryFilterSelection>, customStartDate: Binding<Date>, customEndDate: Binding<Date>) {
        _selection = selection
        _customStartDate = customStartDate
        _customEndDate = customEndDate
    }

    internal var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            fieldTitle("Range")
            Picker("Range", selection: $selection) {
                Text("Last 7 Days").tag(HistoryFilterSelection.last7Days)
                Text("Last 30 Days").tag(HistoryFilterSelection.last30Days)
                Text("Custom").tag(HistoryFilterSelection.custom)
            }
            .pickerStyle(.segmented)

            if selection == .custom {
                fieldTitle("Custom Dates")
                DatePicker("Start", selection: $customStartDate, displayedComponents: .date)
                    .datePickerStyle(.compact)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 10)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(inputBackground)
                DatePicker("End", selection: $customEndDate, displayedComponents: .date)
                    .datePickerStyle(.compact)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 10)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(inputBackground)
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

    private func fieldTitle(_ title: String) -> some View {
        Text(title.uppercased())
            .font(.caption.weight(.bold))
            .foregroundStyle(AppTheme.muted)
    }
}

#if DEBUG
    #Preview {
        HistoryFilterFormCardComponent(
            selection: .constant(.custom),
            customStartDate: .constant(Date()),
            customEndDate: .constant(Date())
        )
        .padding()
        .background(AppTheme.pageGradient)
    }
#endif
