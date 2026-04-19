import Foundation

struct DailyPuzzleService {
    private static let progressKeyPrefix          = "progress_"
    private static let solvedKeyPrefix            = "solved_"
    private static let selectedDifficultyKeyPrefix = "selectedDifficulty_"
    private static let referenceDate: Date = {
        var components = DateComponents()
        components.year = 2026
        components.month = 1
        components.day = 1
        return Calendar.current.date(from: components)!
    }()

    // MARK: - Difficulty Selection

    static func selectedDifficulty(for date: Date = today()) -> DifficultyLevel? {
        let key = selectedDifficultyKey(for: date)
        guard let raw = UserDefaults.standard.string(forKey: key) else { return nil }
        return DifficultyLevel(rawValue: raw)
    }

    static func saveDifficulty(_ difficulty: DifficultyLevel, for date: Date = today()) {
        UserDefaults.standard.set(difficulty.rawValue, forKey: selectedDifficultyKey(for: date))
    }

    // MARK: - Puzzle Access

    static func todaysPuzzle(difficulty: DifficultyLevel) -> Nonogram {
        puzzle(for: today(), difficulty: difficulty)
    }

    /// Returns the date-based daily puzzle for today, or nil if none exists.
    static func todaysDailyPuzzle() -> DailyPuzzleResult? {
        FreeNonoPuzzleLoader.loadDailyPuzzle(for: today())
    }

    static func puzzle(for date: Date, difficulty: DifficultyLevel) -> Nonogram {
        if let daily = FreeNonoPuzzleLoader.loadDailyPuzzle(for: date), daily.difficulty == difficulty {
            return daily.puzzle
        }
        let puzzles = PuzzleLibrary.puzzles(for: difficulty)
        guard !puzzles.isEmpty else {
            return Nonogram(title: "?", rows: 1, cols: 1,
                            rowClues: [[0]], colClues: [[0]],
                            solution: [[false]], difficulty: difficulty)
        }
        let day = dayIndex(for: date)
        return puzzles[day % puzzles.count]
    }

    // MARK: - Progress

    static func saveProgress(_ grid: [[CellState]], for date: Date = today(), difficulty: DifficultyLevel) {
        let key = progressKey(for: date, difficulty: difficulty)
        let flat = grid.flatMap { $0 }.map { $0.rawValue }
        UserDefaults.standard.set(flat, forKey: key)
    }

    static func loadProgress(for date: Date = today(), difficulty: DifficultyLevel) -> [[CellState]]? {
        let key = progressKey(for: date, difficulty: difficulty)
        guard let flat = UserDefaults.standard.array(forKey: key) as? [Int] else { return nil }
        let puzzle = puzzle(for: date, difficulty: difficulty)
        let cells = flat.compactMap { CellState(rawValue: $0) }
        guard cells.count == puzzle.rows * puzzle.cols else { return nil }
        return (0..<puzzle.rows).map { row in
            Array(cells[(row * puzzle.cols)..<((row + 1) * puzzle.cols)])
        }
    }

    // MARK: - Completion Tracking

    static func markSolved(for date: Date = today(), difficulty: DifficultyLevel) {
        UserDefaults.standard.set(true, forKey: solvedKey(for: date, difficulty: difficulty))
    }

    static func wasSolved(for date: Date, difficulty: DifficultyLevel) -> Bool {
        UserDefaults.standard.bool(forKey: solvedKey(for: date, difficulty: difficulty))
    }

    /// Returns true when at least one difficulty was solved on the given date.
    static func wasAnySolved(for date: Date) -> Bool {
        DifficultyLevel.allCases.contains { wasSolved(for: date, difficulty: $0) }
    }

    // MARK: - Utilities

    static func today() -> Date {
        Calendar.current.startOfDay(for: Date())
    }

    static func dateString(for date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }

    // MARK: - Private

    private static func dayIndex(for date: Date) -> Int {
        let days = Calendar.current.dateComponents([.day], from: referenceDate, to: date).day ?? 0
        return max(0, days)
    }

    private static func selectedDifficultyKey(for date: Date) -> String {
        selectedDifficultyKeyPrefix + dateString(for: date)
    }

    private static func progressKey(for date: Date, difficulty: DifficultyLevel) -> String {
        progressKeyPrefix + dateString(for: date) + "_" + difficulty.rawValue
    }

    private static func solvedKey(for date: Date, difficulty: DifficultyLevel) -> String {
        solvedKeyPrefix + dateString(for: date) + "_" + difficulty.rawValue
    }
}
