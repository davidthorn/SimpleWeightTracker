//
//  HealthKitPermissionStatePillComponent.swift
//  SimpleWeightTracker
//
//  Created by David Thorn on 16.02.2026.
//

import SwiftUI

internal struct HealthKitPermissionStatePillComponent: View {
    private let title: String
    private let state: HealthKitAuthorizationState

    internal init(title: String, state: HealthKitAuthorizationState) {
        self.title = title
        self.state = state
    }

    internal var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title.uppercased())
                .font(.caption2.weight(.bold))
                .foregroundStyle(AppTheme.muted)
            Text(state.displayText)
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(.primary)
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .fill(tint(for: state).opacity(0.12))
                .overlay(
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .stroke(tint(for: state).opacity(0.3), lineWidth: 1)
                )
        )
    }

    private func tint(for state: HealthKitAuthorizationState) -> Color {
        switch state {
        case .authorized:
            return AppTheme.success
        case .denied:
            return AppTheme.error
        case .notDetermined:
            return AppTheme.warning
        case .unavailable:
            return AppTheme.muted
        }
    }
}

#if DEBUG
    #Preview {
        HStack {
            HealthKitPermissionStatePillComponent(title: "Read", state: .authorized)
            HealthKitPermissionStatePillComponent(title: "Write", state: .denied)
        }
        .padding()
        .background(AppTheme.pageGradient)
    }
#endif
