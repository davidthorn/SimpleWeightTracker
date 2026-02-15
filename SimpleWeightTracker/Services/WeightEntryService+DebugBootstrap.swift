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
            let dayOffsets = [-5, -4, -3, -2, -1, 0]
            let entriesPerDay = [4, 5, 6, 4, 5, 6]
            let valueTemplates: [[Double]] = [
                [92.6, 92.3, 92.1, 91.9],
                [91.8, 91.7, 91.5, 91.4, 91.2],
                [91.1, 90.9, 90.8, 90.7, 90.5, 90.4],
                [90.2, 90.1, 89.9, 89.8],
                [89.7, 89.5, 89.4, 89.2, 89.1],
                [88.9, 88.8, 88.6, 88.5, 88.3, 88.1]
            ]
            let minuteOffsets = [0, 170, 390, 710, 930, 1170]

            for (dayIndex, dayOffset) in dayOffsets.enumerated() {
                guard let day = calendar.date(byAdding: .day, value: dayOffset, to: today) else {
                    continue
                }

                let entries = buildEntries(
                    for: day,
                    count: entriesPerDay[dayIndex],
                    values: valueTemplates[dayIndex],
                    minuteOffsets: minuteOffsets
                )

                for entry in entries {
                    try await weightEntryStore.upsertEntry(entry)
                }
            }
        }

        private func buildEntries(
            for day: Date,
            count: Int,
            values: [Double],
            minuteOffsets: [Int]
        ) -> [WeightEntry] {
            let calendar = Calendar.current
            let baseDate = calendar.startOfDay(for: day)

            return (0..<count).compactMap { index in
                guard
                    index < values.count,
                    index < minuteOffsets.count,
                    let measuredAt = calendar.date(byAdding: .minute, value: minuteOffsets[index], to: baseDate)
                else {
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
