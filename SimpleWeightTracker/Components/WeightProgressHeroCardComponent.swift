//
//  WeightProgressHeroCardComponent.swift
//  SimpleWeightTracker
//
//  Created by David Thorn on 16.02.2026.
//

import SwiftUI

internal struct WeightProgressHeroCardComponent: View {
    private let title: String
    private let message: String
    private let systemImage: String
    private let tint: Color

    internal init(title: String, message: String, systemImage: String, tint: Color) {
        self.title = title
        self.message = message
        self.systemImage = systemImage
        self.tint = tint
    }

    internal var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: systemImage)
                .font(.title3.weight(.semibold))
                .foregroundStyle(tint)
                .frame(width: 30, height: 30)

            VStack(alignment: .leading, spacing: 6) {
                Text(title)
                    .font(.headline)
                Text(message)
                    .font(.footnote)
                    .foregroundStyle(AppTheme.muted)
            }
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(AppTheme.cardBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .stroke(tint.opacity(0.2), lineWidth: 1)
                )
        )
    }
}

#if DEBUG
    #Preview {
        WeightProgressHeroCardComponent(
            title: "Goal Distance",
            message: "You are 2.7 kg from target.",
            systemImage: "chart.line.uptrend.xyaxis",
            tint: AppTheme.accent
        )
        .padding()
        .background(AppTheme.pageGradient)
    }
#endif
