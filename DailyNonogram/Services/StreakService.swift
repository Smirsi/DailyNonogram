import Foundation

struct StreakService {

    // MARK: - Keys

    private static let frozenDatesKey        = "streak_frozenDates"
    private static let solveSpentKey         = "streak_solveSpentFreezes"
    private static let purchasedTokensKey    = "streak_purchasedFreezeTokens"
    private static let starterFreezeKey      = "hasReceivedStarterFreeze"

    // MARK: - Limits

    static let freeFreezeLimit     = 2
    static let premiumFreezeLimit  = 10

    // MARK: - Public API

    /// Consecutive days with at least 1 solved puzzle (frozen days included).
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

    /// Total freeze tokens available (earned + purchased, respecting the dynamic limit).
    static func availableFreezes(isPremium: Bool) -> Int {
        let baseLimit = isPremium ? premiumFreezeLimit : freeFreezeLimit
        let purchased = purchasedFreezeTokens()
        let effectiveLimit = baseLimit + purchased
        let used = loadFrozenDates().count + UserDefaults.standard.integer(forKey: solveSpentKey)
        let earned = earnedFreezes(isPremium: isPremium)
        return max(0, min(earned, effectiveLimit) - used + purchased)
    }

    /// Spends one freeze token for auto-solve. Prefers purchased tokens. Returns false if none available.
    @discardableResult
    static func spendFreezeForSolve(isPremium: Bool) -> Bool {
        guard availableFreezes(isPremium: isPremium) > 0 else { return false }
        let purchased = purchasedFreezeTokens()
        if purchased > 0 {
            UserDefaults.standard.set(purchased - 1, forKey: purchasedTokensKey)
        } else {
            let current = UserDefaults.standard.integer(forKey: solveSpentKey)
            UserDefaults.standard.set(current + 1, forKey: solveSpentKey)
        }
        return true
    }

    /// Adds purchased freeze tokens (e.g. from IAP or welcome bonus).
    static func addPurchasedFreezeTokens(_ count: Int) {
        let current = purchasedFreezeTokens()
        UserDefaults.standard.set(current + count, forKey: purchasedTokensKey)
    }

    /// Grants starter freeze on first launch. Returns true if granted (first time only).
    @discardableResult
    static func grantStarterFreezeIfNeeded() -> Bool {
        guard !UserDefaults.standard.bool(forKey: starterFreezeKey) else { return false }
        UserDefaults.standard.set(true, forKey: starterFreezeKey)
        addPurchasedFreezeTokens(1)
        return true
    }

    /// Returns true when yesterday was missed and a freeze can rescue the streak.
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

    /// Applies a freeze token to the given date. Prefers purchased tokens.
    @discardableResult
    static func applyFreeze(for date: Date, isPremium: Bool) -> Bool {
        guard availableFreezes(isPremium: isPremium) > 0 else { return false }
        var frozen = loadFrozenDates()
        let dateStr = DailyPuzzleService.dateString(for: date)
        guard !frozen.contains(dateStr) else { return false }
        frozen.append(dateStr)
        saveFrozenDates(frozen)
        let purchased = purchasedFreezeTokens()
        if purchased > 0 {
            UserDefaults.standard.set(purchased - 1, forKey: purchasedTokensKey)
        }
        return true
    }

    static func purchasedFreezeTokens() -> Int {
        UserDefaults.standard.integer(forKey: purchasedTokensKey)
    }

    // MARK: - Private

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
