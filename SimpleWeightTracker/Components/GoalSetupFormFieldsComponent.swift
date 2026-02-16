//
//  GoalSetupFormFieldsComponent.swift
//  SimpleWeightTracker
//
//  Created by David Thorn on 16.02.2026.
//

import SwiftUI

internal struct GoalSetupFormFieldsComponent: View {
    @Binding private var targetValueText: String
    @Binding private var selectedUnit: WeightUnit

    internal init(targetValueText: Binding<String>, selectedUnit: Binding<WeightUnit>) {
        _targetValueText = targetValueText
        _selectedUnit = selectedUnit
    }

    internal var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            fieldTitle("Target Weight")
            TextField("e.g. 70.0", text: $targetValueText)
                .keyboardType(.decimalPad)
                .padding(.horizontal, 12)
                .padding(.vertical, 10)
                .background(inputBackground)

            fieldTitle("Unit")
            Picker("Unit", selection: $selectedUnit) {
                Text("kg").tag(WeightUnit.kilograms)
                Text("lb").tag(WeightUnit.pounds)
            }
            .pickerStyle(.segmented)
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
        GoalSetupFormFieldsComponent(
            targetValueText: .constant("85.0"),
            selectedUnit: .constant(.kilograms)
        )
        .padding()
        .background(AppTheme.pageGradient)
    }
#endif
