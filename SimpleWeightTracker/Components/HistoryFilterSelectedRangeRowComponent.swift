//
//  HistoryFilterSelectedRangeRowComponent.swift
//  SimpleWeightTracker
//
//  Created by David Thorn on 16.02.2026.
//

import SwiftUI

internal struct HistoryFilterSelectedRangeRowComponent: View {
    private let title: String
    private let value: String

    internal init(title: String, value: String) {
        self.title = title
        self.value = value
    }

    internal var body: some View {
        HStack {
            Text(title)
                .font(.subheadline.weight(.semibold))
            Spacer()
            Text(value)
                .font(.subheadline)
                .foregroundStyle(AppTheme.muted)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 9)
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
        HistoryFilterSelectedRangeRowComponent(title: "Start", value: "16 Feb 2026")
            .padding()
            .background(AppTheme.pageGradient)
    }
#endif
