//
//  DayDetailStatPillComponent.swift
//  SimpleWeightTracker
//
//  Created by David Thorn on 15.02.2026.
//

import SwiftUI

internal struct DayDetailStatPillComponent: View {
    internal let title: String
    internal let value: String
    internal let symbol: String
    internal let tint: Color

    internal var body: some View {
        HStack(spacing: 7) {
            Image(systemName: symbol)
                .font(.caption.weight(.semibold))
                .foregroundStyle(tint)

            VStack(alignment: .leading, spacing: 1) {
                Text(title)
                    .font(.caption2.weight(.medium))
                    .foregroundStyle(AppTheme.muted)
                Text(value)
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.primary)
            }

            Spacer(minLength: 0)
        }
        .padding(.horizontal, 9)
        .padding(.vertical, 7)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .fill(Color.white.opacity(0.76))
        )
    }
}

#if DEBUG
    #Preview {
        DayDetailStatPillComponent(
            title: "Avg",
            value: "89.2 kg",
            symbol: "sum",
            tint: AppTheme.accent
        )
        .padding()
    }
#endif
