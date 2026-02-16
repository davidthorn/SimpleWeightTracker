//
//  ProgressRangeLegendComponent.swift
//  SimpleWeightTracker
//
//  Created by David Thorn on 16.02.2026.
//

import SwiftUI

internal struct ProgressRangeLegendComponent: View {
    internal let tint: Color

    internal var body: some View {
        HStack(spacing: 14) {
            legendItem(title: "Weight", color: tint)
            legendItem(title: "7-day avg", color: AppTheme.warning)
            Spacer()
        }
    }

    private func legendItem(title: String, color: Color) -> some View {
        HStack(spacing: 6) {
            Capsule(style: .continuous)
                .fill(color)
                .frame(width: 20, height: 4)
            Text(title)
                .font(.caption.weight(.semibold))
                .foregroundStyle(AppTheme.muted)
        }
    }
}

#if DEBUG
    #Preview {
        ProgressRangeLegendComponent(tint: AppTheme.accent)
            .padding()
            .background(AppTheme.pageGradient)
    }
#endif
