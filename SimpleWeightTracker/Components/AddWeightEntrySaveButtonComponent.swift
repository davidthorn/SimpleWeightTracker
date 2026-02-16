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
        ActionButtonComponent(
            title: "Save Entry",
            systemImage: "checkmark.circle.fill",
            tint: AppTheme.accent,
            action: action
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
