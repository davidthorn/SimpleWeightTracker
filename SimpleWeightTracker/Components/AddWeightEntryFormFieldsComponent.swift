//
//  AddWeightEntryFormFieldsComponent.swift
//  SimpleWeightTracker
//
//  Created by David Thorn on 16.02.2026.
//

import SwiftUI

internal struct AddWeightEntryFormFieldsComponent: View {
    @Binding private var valueText: String
    @Binding private var selectedUnit: WeightUnit
    @Binding private var measuredAt: Date

    internal init(valueText: Binding<String>, selectedUnit: Binding<WeightUnit>, measuredAt: Binding<Date>) {
        _valueText = valueText
        _selectedUnit = selectedUnit
        _measuredAt = measuredAt
    }

    internal var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            fieldTitle("Weight Value")
            TextField("e.g. 74.6", text: $valueText)
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
            Picker("Unit", selection: $selectedUnit) {
                Text("kg").tag(WeightUnit.kilograms)
                Text("lb").tag(WeightUnit.pounds)
            }
            .pickerStyle(.segmented)

            fieldTitle("Measured At")
            WeightEntryDateTimeInputComponent(measuredAt: $measuredAt)
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
    }

    private func fieldTitle(_ title: String) -> some View {
        Text(title.uppercased())
            .font(.caption.weight(.bold))
            .foregroundStyle(AppTheme.muted)
    }
}

#if DEBUG
    #Preview {
        AddWeightEntryFormFieldsComponent(
            valueText: .constant("84.7"),
            selectedUnit: .constant(.kilograms),
            measuredAt: .constant(Date())
        )
        .padding()
        .background(AppTheme.pageGradient)
    }
#endif
