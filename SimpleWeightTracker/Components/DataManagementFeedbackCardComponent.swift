//
//  DataManagementFeedbackCardComponent.swift
//  SimpleWeightTracker
//
//  Created by David Thorn on 16.02.2026.
//

import SwiftUI

internal struct DataManagementFeedbackCardComponent: View {
    internal let message: String
    internal let isError: Bool

    internal var body: some View {
        let tint = isError ? AppTheme.error : AppTheme.success

        return Text(message)
            .font(.footnote)
            .foregroundStyle(tint)
            .padding(12)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(tint.opacity(0.08))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .stroke(tint.opacity(0.24), lineWidth: 1)
                    )
            )
    }
}

#if DEBUG
    #Preview {
        VStack(spacing: 10) {
            DataManagementFeedbackCardComponent(message: "All data wiped.", isError: false)
            DataManagementFeedbackCardComponent(message: "Unable to wipe all data.", isError: true)
        }
        .padding()
        .background(AppTheme.pageGradient)
    }
#endif
