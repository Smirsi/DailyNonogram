import Foundation

/// Tracks which puzzle difficulty a free user has started today, and which additional
/// difficulties they have unlocked by watching a rewarded ad.
struct PuzzleLockService {

    private static let lockedDifficultyKey  = "puzzleLock_difficulty"
    private static let lockedDateKey        = "puzzleLock_date"
    private static let unlockedDifficultiesKey = "puzzleUnlock_difficulties"
    private static let unlockedDateKey      = "puzzleUnlock_date"

    // MARK: - Locking

    /// Call when the user makes their first move in a puzzle.
    static func lockPuzzle(difficulty: DifficultyLevel, for date: Date = DailyPuzzleService.today()) {
        let dateStr = DailyPuzzleService.dateString(for: date)
        guard UserDefaults.standard.string(forKey: lockedDateKey) != dateStr else { return }
        UserDefaults.standard.set(dateStr, forKey: lockedDateKey)
        UserDefaults.standard.set(difficulty.rawValue, forKey: lockedDifficultyKey)
    }

    /// The difficulty the user locked today, or nil if no puzzle has been started.
    static func lockedDifficulty(for date: Date = DailyPuzzleService.today()) -> DifficultyLevel? {
        let dateStr = DailyPuzzleService.dateString(for: date)
        guard UserDefaults.standard.string(forKey: lockedDateKey) == dateStr else { return nil }
        guard let raw = UserDefaults.standard.string(forKey: lockedDifficultyKey) else { return nil }
        return DifficultyLevel(rawValue: raw)
    }

    /// Returns true if the user has started a different puzzle today (requires ad to play this one).
    static func requiresAdToPlay(difficulty: DifficultyLevel) -> Bool {
        guard let locked = lockedDifficulty() else { return false }
        return locked != difficulty && !isUnlocked(difficulty: difficulty)
    }

    // MARK: - Ad Unlocking

    /// Call after the user successfully watches a rewarded ad for a specific difficulty.
    static func unlockPuzzle(difficulty: DifficultyLevel, for date: Date = DailyPuzzleService.today()) {
        let dateStr = DailyPuzzleService.dateString(for: date)
        if UserDefaults.standard.string(forKey: unlockedDateKey) != dateStr {
            UserDefaults.standard.set(dateStr, forKey: unlockedDateKey)
            UserDefaults.standard.set([String](), forKey: unlockedDifficultiesKey)
        }
        var unlocked = UserDefaults.standard.stringArray(forKey: unlockedDifficultiesKey) ?? []
        if !unlocked.contains(difficulty.rawValue) {
            unlocked.append(difficulty.rawValue)
            UserDefaults.standard.set(unlocked, forKey: unlockedDifficultiesKey)
        }
    }

    /// Returns true if the user has already watched an ad to unlock this difficulty today.
    static func isUnlocked(difficulty: DifficultyLevel, for date: Date = DailyPuzzleService.today()) -> Bool {
        let dateStr = DailyPuzzleService.dateString(for: date)
        guard UserDefaults.standard.string(forKey: unlockedDateKey) == dateStr else { return false }
        let unlocked = UserDefaults.standard.stringArray(forKey: unlockedDifficultiesKey) ?? []
        return unlocked.contains(difficulty.rawValue)
    }
}
