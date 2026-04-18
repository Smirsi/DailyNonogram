import Foundation

struct StreakService {

    // MARK: - Keys

    private static let frozenDatesKey = "streak_frozenDates"

    // MARK: - Public API

    /// Consecutive days with at least 1 solved puzzle (frozen days included).
    /// Starts from today if solved, from yesterday otherwise.
    static func currentStreak() -> Int {
        let cal = Calendar.current
        let today = DailyPuzzleService.today()
        let frozenDates = Set(loadFrozenDates())

        let todayActive = DailyPuzzleService.wasAnySolved(for: today)
                       || frozenDates.contains(DailyPuzzleService.dateString(for: today))
        var date = todayActive ? today : cal.date(byAdding: .day, value: -1, to: today)!
        var count = 0

        while true {
            let dateStr = DailyPuzzleService.dateString(for: date)
            if DailyPuzzleService.wasAnySolved(for: date) || frozenDates.contains(dateStr) {
                count += 1
                date = cal.date(byAdding: .day, value: -1, to: date)!
            } else {
                break
            }
        }
        return count
    }

    /// Freeze tokens available to the user (premium only).
    /// 1 token is earned for every 7 consecutive *solved* days within the current streak.
    static func availableFreezes(isPremium: Bool) -> Int {
        guard isPremium else { return 0 }
        return max(0, earnedFreezes() - loadFrozenDates().count)
    }

    /// Returns true when yesterday was missed, the day before was active,
    /// and the user has a freeze available — i.e. a freeze can rescue the streak.
    static func canApplyFreezeForYesterday(isPremium: Bool) -> Bool {
        guard isPremium, availableFreezes(isPremium: true) > 0 else { return false }
        let cal = Calendar.current
        let today = DailyPuzzleService.today()
        let yesterday = cal.date(byAdding: .day, value: -1, to: today)!
        let dayBefore = cal.date(byAdding: .day, value: -2, to: today)!
        let frozenDates = Set(loadFrozenDates())

        let yesterdayMissed = !DailyPuzzleService.wasAnySolved(for: yesterday)
                           && !frozenDates.contains(DailyPuzzleService.dateString(for: yesterday))
        let dayBeforeActive = DailyPuzzleService.wasAnySolved(for: dayBefore)
                           || frozenDates.contains(DailyPuzzleService.dateString(for: dayBefore))
        return yesterdayMissed && dayBeforeActive
    }

    /// Applies a freeze token to the given date.
    @discardableResult
    static func applyFreeze(for date: Date, isPremium: Bool) -> Bool {
        guard isPremium, availableFreezes(isPremium: true) > 0 else { return false }
        var frozen = loadFrozenDates()
        let dateStr = DailyPuzzleService.dateString(for: date)
        guard !frozen.contains(dateStr) else { return false }
        frozen.append(dateStr)
        saveFrozenDates(frozen)
        return true
    }

    // MARK: - Private

    /// Solved-only days within the current continuous run (frozen days excluded).
    private static func earnedFreezes() -> Int {
        let cal = Calendar.current
        let today = DailyPuzzleService.today()
        let frozenDates = Set(loadFrozenDates())

        let todayActive = DailyPuzzleService.wasAnySolved(for: today)
                       || frozenDates.contains(DailyPuzzleService.dateString(for: today))
        var date = todayActive ? today : cal.date(byAdding: .day, value: -1, to: today)!
        var solvedDays = 0

        while true {
            let dateStr = DailyPuzzleService.dateString(for: date)
            let solved = DailyPuzzleService.wasAnySolved(for: date)
            let frozen = frozenDates.contains(dateStr)

            if solved || frozen {
                if solved { solvedDays += 1 }
                date = cal.date(byAdding: .day, value: -1, to: date)!
            } else {
                break
            }
        }
        return solvedDays / 7
    }

    private static func loadFrozenDates() -> [String] {
        UserDefaults.standard.stringArray(forKey: frozenDatesKey) ?? []
    }

    private static func saveFrozenDates(_ dates: [String]) {
        UserDefaults.standard.set(dates, forKey: frozenDatesKey)
    }
}
