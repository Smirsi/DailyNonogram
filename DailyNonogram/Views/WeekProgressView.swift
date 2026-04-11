import SwiftUI

struct WeekProgressView: View {
    private let days: [DayEntry] = Self.buildDays()

    var body: some View {
        HStack(spacing: 0) {
            ForEach(days) { entry in
                VStack(spacing: 4) {
                    Circle()
                        .fill(entry.isSolved ? DS.accent : Color.clear)
                        .overlay(
                            Circle()
                                .stroke(entry.isToday ? DS.accent : DS.gridLine,
                                        lineWidth: entry.isToday ? 2 : 1)
                        )
                        .frame(width: 22, height: 22)

                    Text(entry.weekday)
                        .font(DS.clueFont())
                        .foregroundStyle(entry.isToday ? DS.textPrimary : DS.textTertiary)
                }
                .frame(maxWidth: .infinity)
            }
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 10)
    }

    // MARK: - Model

    private struct DayEntry: Identifiable {
        let id: Int
        let weekday: String
        let isSolved: Bool
        let isToday: Bool
    }

    private static func buildDays() -> [DayEntry] {
        let cal = Calendar.current
        let today = DailyPuzzleService.today()
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "de_DE")
        formatter.dateFormat = "EE"

        return (0..<7).map { offset in
            let date = cal.date(byAdding: .day, value: offset - 6, to: today)!
            let short = String(formatter.string(from: date).prefix(2)).capitalized
            return DayEntry(
                id: offset,
                weekday: short,
                isSolved: DailyPuzzleService.wasAnySolved(for: date),
                isToday: cal.isDate(date, inSameDayAs: today)
            )
        }
    }
}
