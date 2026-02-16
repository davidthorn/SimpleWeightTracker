//
//  HistoryFilterSelectedRangeCardComponent.swift
//  SimpleWeightTracker
//
//  Created by David Thorn on 16.02.2026.
//

import SwiftUI

internal struct HistoryFilterSelectedRangeCardComponent: View {
    private let selectedRange: ClosedRange<Date>

    internal init(selectedRange: ClosedRange<Date>) {
        self.selectedRange = selectedRange
    }

    internal var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            fieldTitle("Selected Range")
            HistoryFilterSelectedRangeRowComponent(
                title: "Start",
                value: selectedRange.lowerBound.formatted(date: .abbreviated, time: .omitted)
            )
            HistoryFilterSelectedRangeRowComponent(
                title: "End",
                value: selectedRange.upperBound.formatted(date: .abbreviated, time: .omitted)
            )
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
        HistoryFilterSelectedRangeCardComponent(selectedRange: Date().addingTimeInterval(-86_400 * 7)...Date())
            .padding()
            .background(AppTheme.pageGradient)
    }
#endif
