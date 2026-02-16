//
//  FormErrorCardComponent.swift
//  SimpleWeightTracker
//
//  Created by David Thorn on 16.02.2026.
//

import SwiftUI

internal struct FormErrorCardComponent: View {
    private let message: String

    internal init(message: String) {
        self.message = message
    }

    internal var body: some View {
        Text(message)
            .font(.footnote)
            .foregroundStyle(AppTheme.error)
            .padding(12)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(AppTheme.error.opacity(0.08))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .stroke(AppTheme.error.opacity(0.24), lineWidth: 1)
                    )
            )
    }
}

#if DEBUG
    #Preview {
        FormErrorCardComponent(message: "Type: HKError\nDomain: com.apple.healthkit\nCode: 4")
            .padding()
            .background(AppTheme.pageGradient)
    }
#endif
