//
//  UnitsSettingsFormCardComponent.swift
//  SimpleWeightTracker
//
//  Created by David Thorn on 16.02.2026.
//

import SwiftUI

internal struct UnitsSettingsFormCardComponent: View {
    @Binding private var selectedUnit: WeightUnit

    internal init(selectedUnit: Binding<WeightUnit>) {
        _selectedUnit = selectedUnit
    }

    internal var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            fieldTitle("Preferred Unit")
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

    private func fieldTitle(_ title: String) -> some View {
        Text(title.uppercased())
            .font(.caption.weight(.bold))
            .foregroundStyle(AppTheme.muted)
    }
}

#if DEBUG
    #Preview {
        UnitsSettingsFormCardComponent(selectedUnit: .constant(.kilograms))
            .padding()
            .background(AppTheme.pageGradient)
    }
#endif
