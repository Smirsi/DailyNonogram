import Foundation

struct DailyPuzzleService {
    private static let progressKeyPrefix  = "progress_"
    private static let solvedKeyPrefix    = "solved_"
    private static let referenceDate: Date = {
        var components = DateComponents()
        components.year = 2026
        components.month = 1
        components.day = 1
        return Calendar.current.date(from: components)!
    }()

    // MARK: - Public API

    static func todaysPuzzle() -> Nonogram {
        puzzle(for: today())
    }

    /// Override point for future premium / bonus puzzles.
    static func puzzle(for date: Date) -> Nonogram {
        let day = dayIndex(for: date)
        let index = day % PuzzleLibrary.all.count
        return PuzzleLibrary.all[index]
    }

    static func saveProgress(_ grid: [[CellState]], for date: Date = today()) {
        let key = progressKey(for: date)
        let flat = grid.flatMap { $0 }.map { $0.rawValue }
        UserDefaults.standard.set(flat, forKey: key)
    }

    // MARK: - Completion Tracking

    static func markSolved(for date: Date = today()) {
        UserDefaults.standard.set(true, forKey: solvedKey(for: date))
    }

    static func wasSolved(for date: Date) -> Bool {
        UserDefaults.standard.bool(forKey: solvedKey(for: date))
    }

    private static func solvedKey(for date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return solvedKeyPrefix + formatter.string(from: date)
    }

    // MARK: - Progress

    static func loadProgress(for date: Date = today()) -> [[CellState]]? {
        let key = progressKey(for: date)
        guard let flat = UserDefaults.standard.array(forKey: key) as? [Int] else { return nil }
        let puzzle = puzzle(for: date)
        let cells = flat.compactMap { CellState(rawValue: $0) }
        guard cells.count == puzzle.rows * puzzle.cols else { return nil }
        return (0..<puzzle.rows).map { row in
            Array(cells[(row * puzzle.cols)..<((row + 1) * puzzle.cols)])
        }
    }

    // MARK: - Private

    static func today() -> Date {
        Calendar.current.startOfDay(for: Date())
    }

    private static func dayIndex(for date: Date) -> Int {
        let days = Calendar.current.dateComponents([.day], from: referenceDate, to: date).day ?? 0
        return max(0, days)
    }

    private static func progressKey(for date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return progressKeyPrefix + formatter.string(from: date)
    }
}
