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

    /// Freeze tokens available to the user.
    /// Free: 1 per 7 consecutive solved days, max 5. Premium: 2 per 7 days, max 10.
    static func availableFreezes(isPremium: Bool) -> Int {
        let maxFreezes = isPremium ? 10 : 5
        let used = loadFrozenDates().count
        return max(0, min(earnedFreezes(isPremium: isPremium) - used, maxFreezes - used))
    }

    /// Returns true when yesterday was missed, the day before was active,
    /// and the user has a freeze available — i.e. a freeze can rescue the streak.
    static func canApplyFreezeForYesterday(isPremium: Bool) -> Bool {
        guard availableFreezes(isPremium: isPremium) > 0 else { return false }
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
        guard availableFreezes(isPremium: isPremium) > 0 else { return false }
        var frozen = loadFrozenDates()
        let dateStr = DailyPuzzleService.dateString(for: date)
        guard !frozen.contains(dateStr) else { return false }
        frozen.append(dateStr)
        saveFrozenDates(frozen)
        return true
    }

    // MARK: - Private

    /// Solved-only days within the current continuous run (frozen days excluded).
    /// Multiplied by 1 for free users, 2 for premium.
    private static func earnedFreezes(isPremium: Bool) -> Int {
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
        let rate = isPremium ? 2 : 1
        return (solvedDays / 7) * rate
    }

    static func loadFrozenDatesPublic() -> [String] {
        loadFrozenDates()
    }

    private static func loadFrozenDates() -> [String] {
        UserDefaults.standard.stringArray(forKey: frozenDatesKey) ?? []
    }

    private static func saveFrozenDates(_ dates: [String]) {
        UserDefaults.standard.set(dates, forKey: frozenDatesKey)
    }
}
