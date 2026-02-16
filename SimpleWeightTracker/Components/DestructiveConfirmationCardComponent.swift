//
//  DestructiveConfirmationCardComponent.swift
//  SimpleWeightTracker
//
//  Created by David Thorn on 16.02.2026.
//

import SwiftUI

internal struct DestructiveConfirmationCardComponent: View {
    internal let title: String
    internal let message: String
    internal let confirmTitle: String
    internal let tint: Color
    internal let isDisabled: Bool
    internal let onCancel: () -> Void
    internal let onConfirm: () -> Void

    internal var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(alignment: .top, spacing: 10) {
                Image(systemName: "exclamationmark.triangle.fill")
                    .font(.subheadline.weight(.bold))
                    .foregroundStyle(tint)
                    .padding(9)
                    .background(
                        Circle()
                            .fill(tint.opacity(0.14))
                    )

                VStack(alignment: .leading, spacing: 3) {
                    Text(title)
                        .font(.headline)
                    Text(message)
                        .font(.footnote)
                        .foregroundStyle(AppTheme.muted)
                }
                Spacer()
            }

            HStack(spacing: 10) {
                Button("Cancel", action: onCancel)
                    .buttonStyle(.plain)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(AppTheme.muted)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 11)
                    .background(
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .fill(Color.white.opacity(0.82))
                            .overlay(
                                RoundedRectangle(cornerRadius: 12, style: .continuous)
                                    .stroke(AppTheme.border, lineWidth: 1)
                            )
                    )
                    .disabled(isDisabled)

                Button(confirmTitle, action: onConfirm)
                    .buttonStyle(.plain)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 11)
                    .background(
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .fill(tint)
                            .opacity(isDisabled ? 0.45 : 1)
                    )
                    .disabled(isDisabled)
            }
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(AppTheme.cardBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .stroke(tint.opacity(0.22), lineWidth: 1)
                )
        )
    }
}

#if DEBUG
    #Preview {
        DestructiveConfirmationCardComponent(
            title: "Delete this entry?",
            message: "This action cannot be undone.",
            confirmTitle: "Delete Entry",
            tint: AppTheme.error,
            isDisabled: false,
            onCancel: {},
            onConfirm: {}
        )
        .padding()
        .background(AppTheme.pageGradient)
    }
#endif
