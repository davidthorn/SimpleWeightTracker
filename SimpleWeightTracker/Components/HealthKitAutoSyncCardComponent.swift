//
//  HealthKitAutoSyncCardComponent.swift
//  SimpleWeightTracker
//
//  Created by David Thorn on 16.02.2026.
//

import SwiftUI

internal struct HealthKitAutoSyncCardComponent: View {
    @Binding private var isAutoSyncEnabled: Bool
    private let isHealthKitAvailable: Bool

    internal init(isAutoSyncEnabled: Binding<Bool>, isHealthKitAvailable: Bool) {
        _isAutoSyncEnabled = isAutoSyncEnabled
        self.isHealthKitAvailable = isHealthKitAvailable
    }

    internal var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 10) {
                Image(systemName: "arrow.triangle.2.circlepath")
                    .font(.subheadline.weight(.bold))
                    .foregroundStyle(AppTheme.success)
                    .frame(width: 28, height: 28)
                    .background(
                        RoundedRectangle(cornerRadius: 8, style: .continuous)
                            .fill(AppTheme.success.opacity(0.12))
                    )

                VStack(alignment: .leading, spacing: 3) {
                    Text("Auto-Sync New Entries")
                        .font(.subheadline.weight(.semibold))
                    Text("When enabled, newly created weight logs are also saved to HealthKit.")
                        .font(.footnote)
                        .foregroundStyle(AppTheme.muted)
                }

                Spacer()

                Toggle("", isOn: $isAutoSyncEnabled)
                    .labelsHidden()
                    .disabled(isHealthKitAvailable == false)
            }
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(AppTheme.cardBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .stroke(AppTheme.border, lineWidth: 1)
                )
        )
    }
}

#if DEBUG
    #Preview {
        HealthKitAutoSyncCardComponent(
            isAutoSyncEnabled: .constant(true),
            isHealthKitAvailable: true
        )
        .padding()
        .background(AppTheme.pageGradient)
    }
#endif
