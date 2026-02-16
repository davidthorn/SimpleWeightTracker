//
//  WeightEntryService+DebugBootstrap.swift
//  SimpleWeightTracker
//
//  Created by David Thorn on 15.02.2026.
//

#if DEBUG
    import Foundation

    extension WeightEntryService: WeightEntryDebugBootstrapServiceProtocol {
        internal func bootstrapIfNeeded() async throws {
            let existingEntries = try await weightEntryStore.fetchEntries()
            guard existingEntries.isEmpty else {
                return
            }

            let calendar = Calendar.current
            let today = calendar.startOfDay(for: Date())
            let dayCount = 420
            let dayOffsets = Array(-(dayCount - 1)...0)

            for dayOffset in dayOffsets {
                guard let day = calendar.date(byAdding: .day, value: dayOffset, to: today) else {
                    continue
                }

                let entries = buildEntries(for: day, dayOffset: dayOffset, totalDayCount: dayCount)

                for entry in entries {
                    try await weightEntryStore.upsertEntry(entry)
                }
            }
        }

        private func buildEntries(for day: Date, dayOffset: Int, totalDayCount: Int) -> [WeightEntry] {
            let calendar = Calendar.current
            let baseDate = calendar.startOfDay(for: day)
            let dayIndex = dayOffset + (totalDayCount - 1)
            let progress = Double(dayIndex) / Double(totalDayCount - 1)
            let startWeight = 130.0
            let targetWeight = 85.0
            let baseValue = startWeight - ((startWeight - targetWeight) * progress)
            let weeklyVariation = Double((dayIndex % 7) - 3) * 0.04

            let morningValue: Double
            let eveningValue: Double
            if dayIndex == totalDayCount - 1 {
                morningValue = targetWeight
                eveningValue = targetWeight + 0.2
            } else {
                morningValue = baseValue + weeklyVariation
                eveningValue = morningValue + 0.35
            }

            let minuteOffsets = [450, 1320] // 07:30 and 22:00
            let values = [morningValue, eveningValue]

            return minuteOffsets.enumerated().compactMap { index, minuteOffset in
                guard let measuredAt = calendar.date(byAdding: .minute, value: minuteOffset, to: baseDate) else {
                    return nil
                }

                return WeightEntry(
                    id: UUID(),
                    value: values[index],
                    unit: .kilograms,
                    measuredAt: measuredAt
                )
            }
        }
    }
#endif
