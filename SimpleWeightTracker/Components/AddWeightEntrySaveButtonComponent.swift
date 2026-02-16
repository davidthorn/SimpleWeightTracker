//
//  AddWeightEntrySaveButtonComponent.swift
//  SimpleWeightTracker
//
//  Created by David Thorn on 16.02.2026.
//

import SwiftUI

internal struct AddWeightEntrySaveButtonComponent: View {
    private let action: () -> Void

    internal init(action: @escaping () -> Void) {
        self.action = action
    }

    internal var body: some View {
        Button(action: action) {
            Label("Save Entry", systemImage: "checkmark.circle.fill")
                .font(.subheadline.weight(.semibold))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
        }
        .buttonStyle(.plain)
        .foregroundStyle(.white)
        .background(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(AppTheme.accent)
        )
    }
}

#if DEBUG
    #Preview {
        AddWeightEntrySaveButtonComponent(action: {})
            .padding()
            .background(AppTheme.pageGradient)
    }
#endif
