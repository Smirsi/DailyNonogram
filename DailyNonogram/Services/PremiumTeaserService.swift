import Foundation

/// Decides when to show the premium teaser popup.
/// Rules: once per day, only for non-premium users, triggered after solving a puzzle.
struct PremiumTeaserService {
    private static let lastShownKey = "lastPremiumTeaserShown"

    /// Returns true if the teaser should be shown right now.
    static func shouldShow(isPremium: Bool) -> Bool {
        guard !isPremium else { return false }
        let today = DailyPuzzleService.dateString(for: DailyPuzzleService.today())
        let lastShown = UserDefaults.standard.string(forKey: lastShownKey) ?? ""
        return lastShown != today
    }

    /// Call this after showing the teaser to prevent showing it again today.
    static func markShown() {
        let today = DailyPuzzleService.dateString(for: DailyPuzzleService.today())
        UserDefaults.standard.set(today, forKey: lastShownKey)
    }
}
