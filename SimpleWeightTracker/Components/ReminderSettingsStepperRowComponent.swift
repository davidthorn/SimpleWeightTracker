//
//  ReminderSettingsStepperRowComponent.swift
//  SimpleWeightTracker
//
//  Created by David Thorn on 16.02.2026.
//

import SwiftUI

internal struct ReminderSettingsStepperRowComponent: View {
    private let title: String
    @Binding private var value: Int
    private let valueTint: Color
    private let range: ClosedRange<Int>
    private let step: Int

    internal init(
        title: String,
        value: Binding<Int>,
        valueTint: Color,
        range: ClosedRange<Int>,
        step: Int = 1
    ) {
        self.title = title
        _value = value
        self.valueTint = valueTint
        self.range = range
        self.step = step
    }

    internal var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.caption.weight(.bold))
                    .foregroundStyle(AppTheme.muted)
                Text("\(value)")
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(valueTint)
            }
            Spacer()

            Stepper(
                title,
                value: $value,
                in: range,
                step: step
            )
            .labelsHidden()
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 10)
        .background(inputBackground)
    }

    private var inputBackground: some View {
        RoundedRectangle(cornerRadius: 10, style: .continuous)
            .fill(Color.white.opacity(0.66))
            .overlay(
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .stroke(AppTheme.border, lineWidth: 1)
            )
    }
}

#if DEBUG
    #Preview {
        ReminderSettingsStepperRowComponent(
            title: "Interval Minutes",
            value: .constant(60),
            valueTint: AppTheme.warning,
            range: 30...360,
            step: 30
        )
        .padding()
        .background(AppTheme.pageGradient)
    }
#endif
