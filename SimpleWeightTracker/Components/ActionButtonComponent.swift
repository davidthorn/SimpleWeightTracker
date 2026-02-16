//
//  ActionButtonComponent.swift
//  SimpleWeightTracker
//
//  Created by David Thorn on 16.02.2026.
//

import SwiftUI

internal struct ActionButtonComponent: View {
    private let title: String
    private let systemImage: String
    private let tint: Color
    private let isCancelStyle: Bool
    private let font: Font
    private let verticalPadding: CGFloat
    private let cornerRadius: CGFloat
    private let action: () -> Void

    internal init(
        title: String,
        systemImage: String,
        tint: Color,
        isCancelStyle: Bool = false,
        font: Font = .subheadline.weight(.semibold),
        verticalPadding: CGFloat = 12,
        cornerRadius: CGFloat = 12,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.systemImage = systemImage
        self.tint = tint
        self.isCancelStyle = isCancelStyle
        self.font = font
        self.verticalPadding = verticalPadding
        self.cornerRadius = cornerRadius
        self.action = action
    }

    internal var body: some View {
        Button(action: action) {
            Label(title, systemImage: systemImage)
                .font(font)
                .foregroundStyle(isCancelStyle ? AppTheme.muted : .white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, verticalPadding)
                .background(
                    RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                        .fill(isCancelStyle ? AppTheme.secondaryActionBackground : tint)
                        .overlay(
                            RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                                .stroke(isCancelStyle ? AppTheme.border : .clear, lineWidth: 1)
                        )
                )
                .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}

#if DEBUG
    #Preview {
        ActionButtonComponent(
            title: "Save",
            systemImage: "checkmark.circle.fill",
            tint: AppTheme.accent,
            action: {}
        )
        .padding()
        .background(AppTheme.pageGradient)
    }
#endif
