//
//  WeightEntryDateTimeInputComponent.swift
//  SimpleWeightTracker
//
//  Created by David Thorn on 15.02.2026.
//

import SwiftUI

internal struct WeightEntryDateTimeInputComponent: View {
    @Binding internal var measuredAt: Date
    @State private var showingDateTimePicker: Bool

    internal init(measuredAt: Binding<Date>) {
        _measuredAt = measuredAt
        _showingDateTimePicker = State(initialValue: false)
    }

    internal var body: some View {
        Button {
            showingDateTimePicker = true
        } label: {
            HStack(spacing: 10) {
                Image(systemName: "calendar.badge.clock")
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(AppTheme.accent)
                    .frame(width: 28, height: 28)
                    .background(
                        Circle()
                            .fill(AppTheme.accent.opacity(0.14))
                    )

                VStack(alignment: .leading, spacing: 2) {
                    Text(measuredAt.formatted(date: .abbreviated, time: .omitted))
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(.primary)
                    Text(measuredAt.formatted(date: .omitted, time: .shortened))
                        .font(.caption.weight(.medium))
                        .foregroundStyle(AppTheme.muted)
                }

                Spacer()

                Text("Edit")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(AppTheme.accent)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 5)
                    .background(
                        Capsule(style: .continuous)
                            .fill(AppTheme.accent.opacity(0.14))
                    )
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 10)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(inputBackground)
        }
        .buttonStyle(.plain)
        .sheet(isPresented: $showingDateTimePicker) {
            NavigationStack {
                ZStack {
                    AppTheme.pageGradient
                        .ignoresSafeArea()

                    VStack(alignment: .leading, spacing: 14) {
                        formHeader

                        VStack(alignment: .leading, spacing: 10) {
                            fieldTitle("Date")
                            DatePicker(
                                "Date",
                                selection: $measuredAt,
                                displayedComponents: .date
                            )
                            .datePickerStyle(.graphical)
                            .labelsHidden()
                            .padding(.horizontal, 6)
                            .padding(.bottom, 4)
                        }
                        .padding(14)
                        .background(cardBackground)

                        VStack(alignment: .leading, spacing: 10) {
                            fieldTitle("Time")
                            DatePicker(
                                "Time",
                                selection: $measuredAt,
                                displayedComponents: .hourAndMinute
                            )
                            .datePickerStyle(.wheel)
                            .labelsHidden()
                            .frame(maxWidth: .infinity)
                            .frame(height: 150)
                            .clipped()
                        }
                        .padding(14)
                        .background(cardBackground)

                        Spacer()
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                }
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("Done") {
                            showingDateTimePicker = false
                        }
                        .font(.subheadline.weight(.semibold))
                    }
                }
            }
            .tint(AppTheme.accent)
        }
    }

    private var cardBackground: some View {
        RoundedRectangle(cornerRadius: 16, style: .continuous)
            .fill(AppTheme.cardBackground)
            .overlay(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .stroke(AppTheme.border, lineWidth: 1)
            )
    }

    private var inputBackground: some View {
        RoundedRectangle(cornerRadius: 10, style: .continuous)
            .fill(Color.white.opacity(0.66))
            .overlay(
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .stroke(AppTheme.border, lineWidth: 1)
            )
    }

    private var formHeader: some View {
        HStack(alignment: .top, spacing: 10) {
            Image(systemName: "calendar.badge.clock")
                .font(.subheadline.weight(.bold))
                .foregroundStyle(AppTheme.accent)
                .padding(9)
                .background(
                    Circle()
                        .fill(AppTheme.accent.opacity(0.14))
                )
            VStack(alignment: .leading, spacing: 3) {
                Text("Adjust Date & Time")
                    .font(.headline)
                Text("Pick when this measurement was captured.")
                    .font(.footnote)
                    .foregroundStyle(AppTheme.muted)
            }
            Spacer()
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(AppTheme.cardBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .stroke(AppTheme.accent.opacity(0.2), lineWidth: 1)
                )
        )
    }

    private func fieldTitle(_ title: String) -> some View {
        Text(title.uppercased())
            .font(.caption.weight(.bold))
            .foregroundStyle(AppTheme.muted)
    }
}

#if DEBUG
    private struct WeightEntryDateTimeInputPreviewWrapper: View {
        @State private var measuredAt: Date = Date()

        var body: some View {
            WeightEntryDateTimeInputComponent(measuredAt: $measuredAt)
                .padding()
                .background(AppTheme.pageGradient)
        }
    }

    #Preview {
        WeightEntryDateTimeInputPreviewWrapper()
    }
#endif
