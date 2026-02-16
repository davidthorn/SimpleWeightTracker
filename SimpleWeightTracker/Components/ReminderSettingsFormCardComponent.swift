//
//  ReminderSettingsFormCardComponent.swift
//  SimpleWeightTracker
//
//  Created by David Thorn on 16.02.2026.
//

import SwiftUI

internal struct ReminderSettingsFormCardComponent: View {
    @Binding private var isEnabled: Bool
    @Binding private var startHour: Int
    @Binding private var endHour: Int
    @Binding private var intervalMinutes: Int

    internal init(isEnabled: Binding<Bool>, startHour: Binding<Int>, endHour: Binding<Int>, intervalMinutes: Binding<Int>) {
        _isEnabled = isEnabled
        _startHour = startHour
        _endHour = endHour
        _intervalMinutes = intervalMinutes
    }

    internal var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Toggle(isOn: $isEnabled) {
                Text("Enabled")
                    .font(.subheadline.weight(.semibold))
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 10)
            .background(inputBackground)

            if isEnabled {
                ReminderSettingsStepperRowComponent(
                    title: "Start Hour",
                    value: $startHour,
                    valueTint: AppTheme.accent,
                    range: 0...23
                )

                ReminderSettingsStepperRowComponent(
                    title: "End Hour",
                    value: $endHour,
                    valueTint: AppTheme.success,
                    range: 0...23
                )

                ReminderSettingsStepperRowComponent(
                    title: "Interval Minutes",
                    value: $intervalMinutes,
                    valueTint: AppTheme.warning,
                    range: 30...360,
                    step: 30
                )
            } else {
                Text("Enable reminders to configure start, end, and interval.")
                    .font(.footnote)
                    .foregroundStyle(AppTheme.muted)
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
}

#if DEBUG
    #Preview {
        ReminderSettingsFormCardComponent(
            isEnabled: .constant(true),
            startHour: .constant(8),
            endHour: .constant(20),
            intervalMinutes: .constant(120)
        )
        .padding()
        .background(AppTheme.pageGradient)
    }
#endif
